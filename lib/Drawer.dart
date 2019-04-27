import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextAppDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  TextAppDrawer({@required this.store});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
          child: BlurOverlay(
              enabled: BlurSettings(store).getDrawerBlur(),
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
                        store.state.settingsDrawer
                            ? Constants.textConfigs
                            : Constants.textFavs,
                        style: Constants().textstyleText(
                            store.state.textSize),
                      )),
                  Expanded(child: store.state.settingsDrawer ? SettingsDrawer(
                      store: store) : FavoritesDrawer(store: store)),
                  ListTile(
                    title: Text(
                      store.state.settingsDrawer
                          ? Constants.textFavs
                          : Constants.textConfigs,
                      style: Constants().textstyleTitle(
                          store.state.textSize / 16 * 9),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      store.dispatch(UpdateSettingsBool(
                          boolean: !store.state.settingsDrawer));
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
