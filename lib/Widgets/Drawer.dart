import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/Widgets/FavoritesDrawer.dart';
import 'package:textos/Widgets/SettingsDrawer.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextAppDrawer extends StatefulWidget {
  final Store<AppStateMain> store;

  TextAppDrawer({@required this.store});

  createState() => new TextAppDrawerState(store: store);
}

class TextAppDrawerState extends State<TextAppDrawer> {
  final Store<AppStateMain> store;

  TextAppDrawerState({@required this.store});

  bool _settingsDrawer = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
          child: BlurOverlay(
              enabled: BlurSettings(store: store).getDrawerBlur(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .padding
                        .top,
                  ),
                  Center(
                      child: Text(
                        _settingsDrawer
                            ? Constants.textConfigs
                            : Constants.textFavs,
                        style: Constants().textstyleText(
                            store.state.textSize),
                      )),
                  Expanded(child: _settingsDrawer ? SettingsDrawer(
                      store: store) : FavoritesDrawer(store: store)),
                  ListTile(
                    title: Text(
                      _settingsDrawer
                          ? Constants.textFavs
                          : Constants.textConfigs,
                      style: Constants().textstyleTitle(
                          store.state.textSize / 16 * 9),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      setState(() {
                        _settingsDrawer = !_settingsDrawer;
                      });
                    },
                  )
                ],
              ))),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}
