import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/favoritesHelper.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/mainView.dart';

// TODO(KalilDev): Document the app
// TODO(KalilDev): Implement tutorial
// TODO(KalilDev): Implement Firebase analytics
// TODO(KalilDev): Let authors upload texts from the app
// TODO(KalilDev): Make tapping the notification open the respective text
Future<void> main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool _enableDarkMode = prefs?.getBool('isDark') ?? false;
  final List<String> _favoritesList =
      prefs?.getStringList('favorites') ?? <String>[];
  final double _textSize = prefs?.getDouble('textSize') ?? 4.5;
  final int _blurSettings = prefs?.getInt('blurSettings') ?? 1;
  String _uid;

  // Clear favorites if the data doesn't contain the documentID needed for
  // setting the statistics on the database
  if (!_favoritesList.any((String s) => s.contains(';'))) {
    _favoritesList.clear();
    prefs.setStringList('favorites', _favoritesList);
  }

  // Get the stored UDID, in order to preserve the favorites if the user either
  // upgraded the system or reinstalled the app
  _uid = prefs?.getString('uid');

  // Check if we already stored an uuid
  if (_uid == null) {
    /// Firebase Login.
    final FirebaseAuth _fireBaseAuth =
        FirebaseAuth.fromApp(Firestore.instance.app);
    FirebaseUser user;
    try {
      user = await _fireBaseAuth.signInAnonymously();
    } catch (e) {
      user = null;
    }

    if (user != null) {
      _uid = user.uid;
      prefs.setString('uid', _uid);
    }
  }
  runApp(StateBuilder(
      enableDarkMode: _enableDarkMode,
      favoritesList: _favoritesList,
      textSize: _textSize,
      blurSettings: _blurSettings,
      uid: _uid));
}

class StateBuilder extends StatefulWidget {
  const StateBuilder(
      {@required this.enableDarkMode,
      @required this.favoritesList,
      @required this.textSize,
      @required this.blurSettings,
      @required this.uid});

  final bool enableDarkMode;
  final List<String> favoritesList;
  final double textSize;
  final int blurSettings;
  final String uid;

  @override
  State<StateBuilder> createState() => StateBuilderState();
}

class StateBuilderState extends State<StateBuilder> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // Check if we are running debug mode
  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(onResume: (Map<String, dynamic> map) {
      final Map<String, String> data = map['data'];
      print('onResume: ' + data.toString());
      final String collection = data['collection'];
      final String id = data['id'];
      print(collection + '/' + id);
      //final snapshot = await Firestore.instance.collection(collection).document(id).get();
      //print(snapshot.data);
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextCardView(data: snapshot.data, store: store)));
    }, onMessage: (Map<String, dynamic> map) {
      final Map<String, String> data = map['data'];
      print('onMessage: ' + data.toString());
      final String collection = data['collection'];
      final String id = data['id'];
      print(collection + '/' + id);
      //final snapshot = await Firestore.instance.collection(collection).document(id).get();
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextCardView(data: snapshot.data, store: store)));
    }, onLaunch: (Map<String, dynamic> map) {
      final Map<String, String> data = map['data'];
      print('onLaunch: ' + data.toString());
      final String collection = data['collection'];
      final String id = data['id'];
      print(collection + '/' + id);
      //final snapshot = await Firestore.instance.collection(collection).document(id).get();
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextCardView(data: snapshot.data, store: store)));
    });
    if (isInDebugMode) {
      _firebaseMessaging.subscribeToTopic('debug');
      _firebaseMessaging.getToken().then((String token) => print(token));
      print('udid: ' + widget.uid.toString());
      print('favorites: ' + widget.favoritesList.toString());
    }
    FavoritesHelper(userId: widget.uid).syncDatabase(widget.favoritesList);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<FavoritesProvider>(
            builder: (_) => FavoritesProvider(
                widget.favoritesList, FavoritesHelper(userId: widget.uid))),
        ChangeNotifierProvider<ThemeProvider>(
            builder: (_) => ThemeProvider(widget.enableDarkMode)),
        ChangeNotifierProvider<BlurProvider>(
            builder: (_) => BlurProvider(widget.blurSettings)),
        ChangeNotifierProvider<TextSizeProvider>(
            builder: (_) => TextSizeProvider(widget.textSize)),
        ChangeNotifierProvider<QueryInfoProvider>(
          builder: (_) => QueryInfoProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider provider, _) {
          ThemeData overrideTheme;
          final ThemeData dark =
              themeDataDark.copyWith(primaryColor: provider.darkPrimaryColor);
          final ThemeData light =
              themeDataLight.copyWith(primaryColor: provider.lightPrimaryColor);

          if (provider.isDarkMode) {
            overrideTheme = dark;
          } else {
            overrideTheme = light;
          }
          final ThemeData actualTheme =
              MediaQuery.platformBrightnessOf(context) == Brightness.dark
                  ? dark
                  : overrideTheme;

          Brightness inverseOf(Brightness b) =>
              b == Brightness.dark ? Brightness.light : Brightness.dark;

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: actualTheme.primaryColor,
              systemNavigationBarIconBrightness:
                  inverseOf(actualTheme.primaryColorBrightness),
              statusBarColor: actualTheme.brightness == Brightness.dark
                  ? Colors.black.withAlpha(100)
                  : Colors.white.withAlpha(100),
              statusBarIconBrightness: inverseOf(actualTheme.brightness)));

          SystemChrome.setEnabledSystemUIOverlays(
              <SystemUiOverlay>[SystemUiOverlay.bottom]);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: dark,
            theme: overrideTheme,
            home: MainView(),
          );
        },
      ),
    );
  }
}
