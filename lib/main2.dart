import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import 'constants.dart';

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final _enableDarkMode = prefs?.getBool('isDark') ?? false;
  (_enableDarkMode == true) ? Constants().setDarkTheme() : Constants()
      .setWhiteTheme();
  final _favoritesSet = prefs?.getStringList('favorites')?.toSet() ??
      Set<String>();
  final _textSize = prefs?.getDouble('textSize') ?? 10.0;

  final store = Store<AppState>(
    reducer,
    distinct: true,
    initialState: AppState(
        enableDarkMode: _enableDarkMode,
        favoritesSet: _favoritesSet,
        textSize: _textSize),
  );

  runApp(StoreProvider<AppState>(
    store: store,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List>(
      distinct: true,
      converter: (store) {
        return [
          store.state.enableDarkMode,
          store.state.favoritesSet,
          store.state.textSize
        ];
      },
      builder: (_, List list) {
        return MaterialApp(
          theme: Constants.themeData,
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Test Redux App',
                style: TextStyle(
                    fontSize: list[2], color: Constants.themeForeground),
              ),
              backgroundColor: Constants.themeBackground,
            ),
            body: SettingsView(),
            drawer: null,
          ),
        );
      },
    );
  }
}

class SettingsView extends StatefulWidget {
  createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  Widget Item(Store<AppState> store, int index) {
    var state = store.state;
    if (index == 0) {
      return SwitchListTile(
        title: Text(
          'Dark Mode',
          style: TextStyle(fontSize: state.textSize),
        ),
        value: state.enableDarkMode,
        onChanged: (value) {
          store.dispatch(UpdateDarkMode(enable: !state.enableDarkMode));
        },
        secondary: Icon(Icons.settings),
      );
    } else if (index == 1) {
      return ListTile(
        trailing: Row(
          children: <Widget>[
            Text(
              'Text size',
              style: TextStyle(fontSize: state.textSize),
            ),
            Spacer(),
            IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                ),
                onPressed: () {
                  if (state.textSize > 3) {
                    store.dispatch(UpdateTextSize(size: state.textSize - 0.5));
                  }
                }),
            IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                ),
                onPressed: () {
                  store.dispatch(UpdateTextSize(size: state.textSize + 0.5));
                })
          ],
        ),
      );
    } else if (index == 2) {
      return ListTile(
        title: Text('Clear fav', style: TextStyle(fontSize: state.textSize),),
        onTap: () {
          store.dispatch(UpdateFavorites(toClear: 0));
        },
      );
    } else if (index == 3) {
      return ListTile(
        title: Text('Remove sup5', style: TextStyle(fontSize: state.textSize),),
        onTap: () {
          store.dispatch(UpdateFavorites(toRemove: 'sup5'));
        },
      );
    } else {
      return ListTile(
        title: Text(
          state.favoritesSet.toList()[index - 4],
          style: TextStyle(fontSize: state.textSize),
        ),
        onTap: () {
          store.dispatch(UpdateFavorites(toAdd: 'sup' + index.toString()));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return
      },
    );
  }
}

// Redux
class AppState {
  AppState(
      {@required this.enableDarkMode,
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

AppState reducer(AppState state, dynamic action) {
  if (action is UpdateDarkMode) {
    if (action.enable) Constants().setDarkTheme();
    if (!action.enable) Constants().setWhiteTheme();
    SharedPreferences.getInstance().then((pref) {
      pref.setBool('isDark', action.enable);
    });

    return AppState(
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

    return AppState(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: fav,
        textSize: state.textSize);
  }

  if (action is UpdateTextSize) {
    SharedPreferences.getInstance().then((pref) {
      pref.setDouble('textSize', action.size);
    });

    return AppState(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: action.size);
  }

  return state;
}
