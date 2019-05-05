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

  // Settings Drawer
  Animation<Offset> _settingsAnimation;

  // Favorites Drawer, favorites and settings top indicator
  Animation<Offset> _toTopAnimation;
  Animation<Offset> _toBottomAnimation;

  // Bottom tile animation
  Animation<Offset> _settingsTileAnimation;
  Animation<Offset> _favoritesTileAnimation;

  @override
  void initState() {
    super.initState();
    // Shared
    _settingsController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 400));
    final Animation curvedAnimation = CurvedAnimation(
        parent: _settingsController, curve: Curves.easeInOut);


    _settingsAnimation =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
            .animate(curvedAnimation);

    _toTopAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.3))
        .animate(curvedAnimation);
    _toBottomAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
            .animate(curvedAnimation);

    _settingsTileAnimation =
        Tween<Offset>(begin: Offset(0.0, 2.0), end: Offset.zero)
            .animate(curvedAnimation);
    _favoritesTileAnimation =
        Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 2.0))
            .animate(curvedAnimation);

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
      settingsDrawer
          ? _settingsController.forward()
          : _settingsController.reverse();
      _settingsDrawer = settingsDrawer;
    }
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
          child: BlurOverlay(
              enabled:
              BlurSettingsParser(blurSettings: store.state.blurSettings)
                  .getDrawerBlur(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .padding
                        .top,
                  ),
                  Stack(
                    children: <Widget>[
                      Center(
                        child: SlideTransition(
                            position: _toBottomAnimation,
                            child: Text(Constants.textConfigs,
                                style: Constants().textstyleText(
                                    store.state.textSize))),
                      ),
                      Center(
                        child: SlideTransition(
                            position: _toTopAnimation,
                            child: Text(Constants.textFavs,
                                style: Constants().textstyleText(
                                    store.state.textSize))),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Stack(
                        children: <Widget>[
                          SlideTransition(
                            position: _settingsAnimation,
                            child: SettingsDrawer(store: store),
                          ),
                          SlideTransition(
                            position: _toTopAnimation,
                            child: FavoritesDrawer(
                                textSize: store.state.textSize,
                                favoriteSet: store.state.favoritesSet,
                                author: store.state.author,
                                tapHandler: FavoritesTap(store: store)),
                          )
                        ],
                      )),
                  ListTile(
                      title: Stack(children: <Widget>[
                        Center(
                            child: SlideTransition(
                                position: _settingsTileAnimation,
                                child: Text(Constants.textConfigs,
                                    style: Constants().textstyleTitle(
                                        store.state.textSize / 16 * 9),
                                    textAlign: TextAlign.center))
                        ),
                        Center(
                            child: SlideTransition(
                                position: _favoritesTileAnimation,
                                child: Text(Constants.textFavs,
                                    style: Constants().textstyleTitle(
                                        store.state.textSize / 16 * 9),
                                    textAlign: TextAlign.center))
                        ),
                      ]),
                      onTap: () =>
                          setState(() {
                            settingsDrawer = !_settingsDrawer;
                          }))
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
