import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/FavoritesTap.dart';
import 'package:textos/Widgets/FavoritesDrawer.dart';
import 'package:textos/Widgets/SettingsDrawer.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextAppDrawer extends StatefulWidget {
  final Store<AppStateMain> store;

  TextAppDrawer({@required this.store});

  createState() => new TextAppDrawerState(store: store);
}

class TextAppDrawerState extends State<TextAppDrawer>
    with TickerProviderStateMixin {
  final Store<AppStateMain> store;

  TextAppDrawerState({@required this.store});

  bool _settingsDrawer = false;
  bool settingsDrawer = false;
  AnimationController _settingsController;
  Animation<RelativeRect> _settingsAnimation;
  Animation<RelativeRect> _favoritesAnimation;

  @override
  void initState() {
    super.initState();
    _settingsController =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _settingsAnimation = _settingsController.drive(
        RelativeRectTween(begin: RelativeRect.fromLTRB(0.0, 0.0, 400.0, 0.0),
            end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0)));
    _favoritesAnimation = _settingsController.drive(
        RelativeRectTween(begin: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
            end: RelativeRect.fromLTRB(0.0, 0.0, 400.0, 0.0)));
    _settingsController.value = 0.0;
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_settingsDrawer != settingsDrawer) {
      settingsDrawer ? _settingsController.forward() : _settingsController
          .reverse();
      _settingsDrawer = settingsDrawer;
    }
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
          child: BlurOverlay(
              enabled: BlurSettingsParser(
                  blurSettings: store.state.blurSettings).getDrawerBlur(),
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
                  Expanded(child: ClipRect(
                    child: Stack(children: <Widget>[
                      PositionedTransition(
                        rect: _settingsAnimation,
                        child: SettingsDrawer(
                            store: store),
                      ),
                      PositionedTransition(
                        rect: _favoritesAnimation,
                        child: FavoritesDrawer(
                            textSize: store.state.textSize,
                            favoriteSet: store.state.favoritesSet,
                            author: store.state.author,
                            tapHandler: FavoritesTap(store: store)),
                      )
                    ],),
                  )),
                  ListTile(
                      title: Text(
                        _settingsDrawer
                            ? Constants.textFavs
                            : Constants.textConfigs,
                        style: Constants().textstyleTitle(
                            store.state.textSize / 16 * 9),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () =>
                          setState(() {
                            settingsDrawer = !_settingsDrawer;
                          })
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
