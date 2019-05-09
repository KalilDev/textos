import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/FavoritesHelper.dart';
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
  String _udid;

  // Clear favorites if the data doesn't contain the documentID needed for
  // setting the statistics on the database
  if (!_favoritesSet.any((string) => string.contains(';'))) {
    _favoritesSet.clear();
    prefs.setStringList('favorites', _favoritesSet.toList());
  }

  // Get the stored UDID, in order to preserve the favorites if the user either
  // upgraded the system or reinstalled the app
  _udid = prefs?.getString('udid') ?? null;

  // Check if we already stored an uuid
  if (_udid == null) {
    // Get an fresh UDID
    _udid = await FlutterUdid.udid;
    prefs.setString('udid', _udid);
  }

  final store = Store<AppStateMain>(
    reducer,
    distinct: true,
    initialState: AppStateMain(
        enableDarkMode: _enableDarkMode,
        favoritesSet: _favoritesSet,
        textSize: _textSize,
        blurSettings: _blurSettings,
        udid: _udid),
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
          store.state.enableDarkMode,
          store.state.favoritesSet,
          store.state.textSize,
          store.state.blurSettings,
          store.state.udid,
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
      print('udid: ' + store.state.udid);
      print('favorites: ' + store.state.favoritesSet.toString());
    }
    FavoritesHelper(udid: store.state.udid).syncDatabase(
        store.state.favoritesSet);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData overrideTheme;

    if (store.state.enableDarkMode) {
      overrideTheme = Constants.themeDataDark;
    } else {
      overrideTheme = Constants.themeDataLight;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: Constants.themeDataDark,
      theme: overrideTheme,
      home: Scaffold(
        body: TextSlideshow(store: store),
        drawer: TextAppDrawer(store: store),
      ),
    );
  }
}

// Redux
class AppStateMain {
  AppStateMain({@required this.enableDarkMode,
    @required this.favoritesSet,
    @required this.textSize,
    @required this.blurSettings,
    @required this.udid,});

  bool enableDarkMode;
  Set<String> favoritesSet;
  double textSize;
  int blurSettings;
  String udid;
}

class UpdateDarkMode {
  UpdateDarkMode({@required this.enable});

  final bool enable;
}

class UpdateFavorites {
  UpdateFavorites({this.toClear, this.toAdd, this.toRemove});

  final int toClear;
  final String toAdd;
  final String toRemove;
}

class UpdateTextSize {
  UpdateTextSize({@required this.size});

  final double size;
}

class UpdateBlurSettings {
  UpdateBlurSettings({@required this.integer});

  final int integer;
}

AppStateMain reducer(AppStateMain state, dynamic action) {
  if (action is UpdateDarkMode) {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool('isDark', action.enable);
    });

    return AppStateMain(
        enableDarkMode: action.enable,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize,
        blurSettings: state.blurSettings,
        udid: state.udid);
  }

  if (action is UpdateFavorites) {
    var _fav = state.favoritesSet;
    if (action.toClear != null) {
      _fav.clear();
      FavoritesHelper(udid: state.udid).syncDatabase(_fav);
    }
    if (action.toAdd != null) {
      _fav.add(action.toAdd);
      FavoritesHelper(udid: state.udid).addFavorite(action.toAdd);
    }
    if (action.toRemove != null) {
      _fav.remove(action.toRemove);
      FavoritesHelper(udid: state.udid).removeFavorite(action.toRemove);
    }

    SharedPreferences.getInstance().then((pref) {
      pref.setStringList('favorites', _fav.toList());
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: _fav,
        textSize: state.textSize,
        blurSettings: state.blurSettings,
        udid: state.udid);
  }

  if (action is UpdateTextSize) {
    SharedPreferences.getInstance().then((pref) {
      pref.setDouble('textSize', action.size);
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: action.size,
        blurSettings: state.blurSettings,
        udid: state.udid);
  }

  if (action is UpdateBlurSettings) {
    SharedPreferences.getInstance().then((pref) {
      pref.setInt('blurSettings', action.integer);
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize,
        blurSettings: action.integer,
        udid: state.udid);
  }

  return state;
}
