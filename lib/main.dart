import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/Constants.dart';
import 'package:textos/Drawer.dart';
import 'package:textos/FirestoreSlideshowView.dart';

// TODO Document the app
// TODO Implement Firestore favorites
// TODO Implement tutorial
// TODO Implement Firebase analytics
// TODO Implement optimization for the slideshow
void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final _enableDarkMode = prefs?.getBool('isDark') ?? false;
  final _favoritesSet = prefs?.getStringList('favorites')?.toSet() ??
      Set<String>();
  final _textSize = prefs?.getDouble('textSize') ?? 4.5;
  final _blurSettings = prefs?.getInt('blurSettings') ?? 1;

  // Clear favorites if the data doesn't contain the documentID needed for
  // setting the statistics on the database
  if (!_favoritesSet.any((string) => string.contains(';'))) {
    _favoritesSet.clear();
    prefs.setStringList('favorites', _favoritesSet.toList());
  }

  final store = Store<AppStateMain>(
    reducer,
    distinct: true,
    initialState: AppStateMain(
        enableDarkMode: _enableDarkMode,
        favoritesSet: _favoritesSet,
        textSize: _textSize,
        settingsDrawer: false,
        blurSettings: _blurSettings),
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
          store.state.blurSettings
        ];
      },
      builder: (_, List list) {
        return SettingsView();
      },
    );
  }
}

class SettingsView extends StatefulWidget {
  createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppStateMain> store) {
        return MaterialApp(
          theme: store.state.enableDarkMode
              ? Constants.themeDataDark
              : Constants.themeDataLight,
          home: Scaffold(
            appBar: Constants().appbarTransparent(store.state.enableDarkMode),
            body: TextSlideshow(store: store),
            drawer: TextAppDrawer(store: store),
          ),
        );
      },
    );
  }
}

// Redux
class AppStateMain {
  AppStateMain({@required this.enableDarkMode,
    @required this.favoritesSet,
    @required this.textSize,
    @required this.settingsDrawer,
    @required this.blurSettings});

  bool enableDarkMode;
  Set<String> favoritesSet;
  double textSize;
  bool settingsDrawer;
  int blurSettings;
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

class UpdateSettingsBool {
  UpdateSettingsBool({@required this.boolean});

  final bool boolean;
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
        settingsDrawer: state.settingsDrawer,
        blurSettings: state.blurSettings);
  }

  if (action is UpdateFavorites) {
    var _fav = state.favoritesSet;

    void _updateFavoritesDB(String path, int operation) async {
      Firestore db = Firestore.instance;
      final collection = path.split('/')[0];
      final docID = path.split('/')[1];
      db.runTransaction((transaction) async {
        final reference = db.collection(collection).document(docID);
        final snapshot = await transaction.get(reference);
        final int current = snapshot?.data['favorites'];
        int target;
        if (current == null) {
          target = 0 + operation;
        } else {
          target = current + operation;
        }

        await transaction.update(reference, {'favorites': target});
      });
    }

    if (action.toClear != null) {
      state.favoritesSet.forEach((string) {
        final path = string.split(';')[1];
        _updateFavoritesDB(path, -1);
      });
      _fav.clear();
    }
    if (action.toAdd != null) {
      final path = action.toAdd.split(';')[1];
      _updateFavoritesDB(path, 1);
      _fav.add(action.toAdd);
    }
    if (action.toRemove != null) {
      final path = action.toRemove.split(';')[1];
      _updateFavoritesDB(path, -1);
      _fav.remove(action.toRemove);
    }

    SharedPreferences.getInstance().then((pref) {
      pref.setStringList('favorites', _fav.toList());
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: _fav,
        textSize: state.textSize,
        settingsDrawer: state.settingsDrawer,
        blurSettings: state.blurSettings);
  }

  if (action is UpdateTextSize) {
    SharedPreferences.getInstance().then((pref) {
      pref.setDouble('textSize', action.size);
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: action.size,
        settingsDrawer: state.settingsDrawer,
        blurSettings: state.blurSettings);
  }

  if (action is UpdateSettingsBool) {
    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize,
        settingsDrawer: action.boolean,
        blurSettings: state.blurSettings);
  }

  if (action is UpdateBlurSettings) {
    SharedPreferences.getInstance().then((pref) {
      pref.setInt('blurSettings', action.integer);
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize,
        settingsDrawer: state.settingsDrawer,
        blurSettings: action.integer);
  }

  return state;
}
