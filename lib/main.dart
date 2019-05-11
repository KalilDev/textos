import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/FavoritesHelper.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:textos/Views/FirestoreSlideshowView.dart';
import 'package:textos/Widgets/Widgets.dart';

// TODO Document the app
// TODO Implement tutorial
// TODO Implement Firebase analytics
// TODO Let authors upload texts from the app
// TODO Make tapping the notification open the respective text
void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final _enableDarkMode = prefs?.getBool('isDark') ?? false;
  final _favoritesSet =
      prefs?.getStringList('favorites')?.toSet() ?? Set<String>();
  final _textSize = prefs?.getDouble('textSize') ?? 4.5;
  final _blurSettings = prefs?.getInt('blurSettings') ?? 1;
  String _uid;

  // Clear favorites if the data doesn't contain the documentID needed for
  // setting the statistics on the database
  if (!_favoritesSet.any((string) => string.contains(';'))) {
    _favoritesSet.clear();
    prefs.setStringList('favorites', _favoritesSet.toList());
  }

  // Get the stored UDID, in order to preserve the favorites if the user either
  // upgraded the system or reinstalled the app
  _uid = prefs?.getString('uid') ?? null;

  // Check if we already stored an uuid
  if (_uid == null) {
    /// Firebase Login.
    FirebaseAuth _fireBaseAuth = FirebaseAuth.fromApp(Firestore.instance.app);
    final user = await _fireBaseAuth.signInAnonymously();
    if (user != null) {
      _uid = user.uid;
      prefs.setString('uid', _uid);
    }
  }

  final store = Store<AppStateMain>(
    reducer,
    distinct: true,
    initialState: AppStateMain(
        favoritesSet: _favoritesSet,
        uid: _uid),
  );

  runApp(StoreProvider<AppStateMain>(
    store: store,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppStateMain, List>(
      distinct: true,
      converter: (store) {
        return [
          store.state.favoritesSet,
          store.state.uid,
        ];
      },
      builder: (_, List list) {
        return StoreBuilder(
            builder: (BuildContext context, Store<AppStateMain> store) {
              return StoreView(store: store);
            });
      },
    );
  }
}

class StoreView extends StatefulWidget {
  final Store store;

  StoreView({@required this.store});

  createState() => StoreViewState(store: store);
}

class StoreViewState extends State<StoreView> {
  Store<AppStateMain> store;

  StoreViewState({@required this.store});

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
      _firebaseMessaging.getToken().then((token) => print(token));
      print('udid: ' + store.state.uid);
      print('favorites: ' + store.state.favoritesSet.toString());
    }
    FavoritesHelper(userId: store.state.uid)
        .syncDatabase(store.state.favoritesSet);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData overrideTheme;

    if (false) {
      overrideTheme = Constants.themeDataDark;
    } else {
      overrideTheme = Constants.themeDataLight;
    }
    return ChangeNotifierProvider<DarkModeProvider>(
      builder: (_) => DarkModeProvider(false),
      child: ChangeNotifierProvider<BlurProvider>(
        builder: (_) => BlurProvider(1),
        child: ChangeNotifierProvider<TextSizeProvider>(
          builder: (_) => TextSizeProvider(4.5),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: Constants.themeDataDark,
            theme: overrideTheme,
            home: Scaffold(
              body: TextSlideshow(store: store),
              drawer: TextAppDrawer(store: store),
            ),
          ),
        ),
      ),
    );
  }
}

// Redux
class AppStateMain {
  AppStateMain({
    @required this.favoritesSet,
    @required this.uid,
  });

  Set<String> favoritesSet;
  String uid;
}

class UpdateFavorites {
  UpdateFavorites({this.toClear, this.toAdd, this.toRemove});

  final int toClear;
  final String toAdd;
  final String toRemove;
}


AppStateMain reducer(AppStateMain state, dynamic action) {

  if (action is UpdateFavorites) {
    var _fav = state.favoritesSet;
    if (action.toClear != null) {
      _fav.clear();
      FavoritesHelper(userId: state.uid).syncDatabase(_fav);
    }
    if (action.toAdd != null) {
      _fav.add(action.toAdd);
      FavoritesHelper(userId: state.uid).addFavorite(action.toAdd);
    }
    if (action.toRemove != null) {
      _fav.remove(action.toRemove);
      FavoritesHelper(userId: state.uid).removeFavorite(action.toRemove);
    }

    SharedPreferences.getInstance().then((pref) {
      pref.setStringList('favorites', _fav.toList());
    });

    return AppStateMain(
        favoritesSet: _fav,
        uid: state.uid);
  }

  return state;
}
