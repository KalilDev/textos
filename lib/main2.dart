import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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
          theme: ThemeData(
            brightness: list[0] ? Brightness.dark : Brightness.light,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Test Redux App',
                style: TextStyle(fontSize: list[2]),
              ),
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
    } else {
      return ListTile(
        title: Text(
          state.favoritesSet.toList()[index - 2],
          style: TextStyle(fontSize: state.textSize),
        ),
        onTap: () {
          var list = state.favoritesSet.toList();
          //list.removeLast();
          list.add('sup' + index.toString());
          store.dispatch(UpdateFavorites(list: list));
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
          itemCount: state.favoritesSet.length + 2,
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
  UpdateFavorites({@required this.list});

  final List<String> list;
}

class UpdateTextSize {
  UpdateTextSize({@required this.size});

  final double size;
}

AppState reducer(AppState state, dynamic action) {
  if (action is UpdateDarkMode) {
    return AppState(
        enableDarkMode: action.enable,
        favoritesSet: state.favoritesSet,
        textSize: state.textSize);
  }

  if (action is UpdateFavorites) {
    return AppState(
        enableDarkMode: state.enableDarkMode,
        favoritesSet: action.list.toSet(),
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
