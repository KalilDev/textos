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

  @override
  void initState() {
    super.initState();
    // Shared
    _settingsController = new AnimationController(
        vsync: this, duration: Constants.durationAnimationMedium);
    final Animation curvedAnimation =
    CurvedAnimation(parent: _settingsController, curve: Curves.easeInOut);

    _settingsAnimation =
        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
            .animate(curvedAnimation);

    _toTopAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -5.0))
        .animate(curvedAnimation);
    _toBottomAnimation =
        Tween<Offset>(begin: Offset(0.0, -5.0), end: Offset.zero)
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
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Drawer(
          child: BlurOverlay(
              enabled: BlurSettings(store.state.blurSettings).drawerBlur,
              child: Stack(
                children: <Widget>[
                  Column(
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
                                    style: textTheme.subhead.copyWith(
                                        color: textTheme.subhead.color
                                            .withAlpha(190)))),
                          ),
                          Center(
                            child: SlideTransition(
                                position: _toTopAnimation,
                                child: Text(Constants.textFavs,
                                    style: textTheme.subhead.copyWith(
                                        color: textTheme.subhead.color
                                            .withAlpha(190)))),
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
                                    favoriteSet: store.state.favoritesSet,
                                    tapHandler: FavoritesTap(store: store)),
                              )
                            ],
                          ))
                    ],
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: settingsDrawer
                        ? MaterialButton(
                        onPressed: () =>
                            setState(() => settingsDrawer = false),
                        color: Theme
                            .of(context)
                            .accentColor,
                        child: Text(Constants.textConfigs,
                            style: textTheme.subhead,
                            textAlign: TextAlign.center))
                        : MaterialButton(
                        onPressed: () =>
                            setState(() => settingsDrawer = true),
                        color: Theme
                            .of(context)
                            .accentColor,
                        child: Text(Constants.textFavs,
                            style: textTheme.subhead,
                            textAlign: TextAlign.center)),
                  ),
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
