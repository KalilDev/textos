import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/Constants.dart';
import 'package:textos/Drawer.dart';
import 'package:textos/FirestoreSlideshowView.dart';

// TODO Document the app
// TODO Implement blur settings
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

  final store = Store<AppStateMain>(
    reducer,
    distinct: true,
    initialState: AppStateMain(
        enableDarkMode: _enableDarkMode,
        favoritesSet: _favoritesSet,
        textSize: _textSize,
        settingsDrawer: false),
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
          store.state.textSize
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
    this.settingsDrawer});

  bool enableDarkMode;
  Set<String> favoritesSet;
  double textSize;
  bool settingsDrawer;
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

AppStateMain reducer(AppStateMain state, dynamic action) {
  if (action is UpdateDarkMode) {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool('isDark', action.enable);
    });

    return AppStateMain(
        enableDarkMode: action.enable,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize,
        settingsDrawer: state.settingsDrawer);
  }

  if (action is UpdateFavorites) {
    var fav = state.favoritesSet;
    if (action.toClear != null) fav.clear();
    if (action.toAdd != null) fav.add(action.toAdd);
    if (action.toRemove != null) fav.remove(action.toRemove);
    SharedPreferences.getInstance().then((pref) {
      pref.setStringList('favorites', fav.toList());
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: fav,
        textSize: state.textSize,
        settingsDrawer: state.settingsDrawer);
  }

  if (action is UpdateTextSize) {
    SharedPreferences.getInstance().then((pref) {
      pref.setDouble('textSize', action.size);
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: action.size,
        settingsDrawer: state.settingsDrawer);
  }

  if (action is UpdateSettingsBool) {
    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize,
        settingsDrawer: action.boolean);
  }

  return state;
}
