import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'constants.dart';

void main() {
  Set<String> favorites;
  favorites = ['random', 'lol'].toSet();
  final store = Store<AppState>(
    reducer,
    distinct: true,
    initialState: AppState(
        enableDarkMode: false, favoritesSet: favorites, textSize: 20.0),
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
      // Would use a StoreConnector & ViewModel in the real world
      builder: (BuildContext context, Store<AppState> store) {
        final state = store.state;
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) => Item(store, index),
          itemCount: state.favoritesSet.length + 4,
        );
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

    return AppState(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: fav,
        textSize: state.textSize);
  }

  if (action is UpdateTextSize) {
    return AppState(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: state.favoritesSet,
        textSize: action.size);
  }

  return state;
}
