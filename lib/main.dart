import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/Constants.dart';
import 'package:textos/Drawer.dart';
import 'package:textos/FirestoreSlideshowView.dart';


void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final _enableDarkMode = prefs?.getBool('isDark') ?? false;
  (_enableDarkMode == true) ? Constants().setDarkTheme() : Constants()
      .setWhiteTheme();
  final _favoritesSet = prefs?.getStringList('favorites')?.toSet() ??
      Set<String>();
  final _textSize = prefs?.getDouble('textSize') ?? 4.5;

  final store = Store<AppStateMain>(
    reducer,
    distinct: true,
    initialState: AppStateMain(
        enableDarkMode: _enableDarkMode,
        favoritesSet: _favoritesSet,
        textSize: _textSize),
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
          theme: Constants.themeData,
          home: Scaffold(
            appBar: Constants().appbarTransparent(),
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
    @required this.textSize});

  bool enableDarkMode;
  Set<String> favoritesSet;
  double textSize;
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

AppStateMain reducer(AppStateMain state, dynamic action) {
  if (action is UpdateDarkMode) {
    if (action.enable) Constants().setDarkTheme();
    if (!action.enable) Constants().setWhiteTheme();
    SharedPreferences.getInstance().then((pref) {
      pref.setBool('isDark', action.enable);
    });

    return AppStateMain(
        enableDarkMode: action.enable,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize);
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
        textSize: state.textSize);
  }

  if (action is UpdateTextSize) {
    SharedPreferences.getInstance().then((pref) {
      pref.setDouble('textSize', action.size);
    });

    return AppStateMain(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: action.size);
  }

  return state;
}
