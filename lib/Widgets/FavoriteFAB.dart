import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/Widgets/BlurOverlay.dart';
import 'package:textos/main.dart';

class FavoriteFAB extends StatefulWidget {
  final Store store;
  final String title;

  FavoriteFAB({@required this.store, @required this.title});

  createState() => FavoriteFABState(store: store, title: title);
}

class FavoriteFABState extends State<FavoriteFAB>
    with TickerProviderStateMixin {
  FavoriteFABState({
    @required this.store,
    @required this.title,
  });

  final Store<AppStateMain> store;
  final String title;

  AnimationController _animationController;
  Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    final favorite = store.state.favoritesSet.toList().contains(title);
    _animationController = new AnimationController(
        duration: Duration(milliseconds: 600), vsync: this);
    _scale = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
    if (favorite) {
      _animationController.repeat(
          min: 0.8, max: 1.0, period: Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorite = store.state.favoritesSet.toList().contains(title);

    return ScaleTransition(
      scale: _scale,
      child: BlurOverlay(
        enabled: BlurSettings(store).getButtonsBlur(),
        radius: 100,
        child: FloatingActionButton(
          backgroundColor: favorite
              ? Theme.of(context).backgroundColor.withAlpha(160)
              : Theme.of(context).accentColor.withAlpha(140),
          child: new Icon(Icons.favorite,
              color: favorite ? Colors.red : Theme.of(context).primaryColor),
          onPressed: () {
            if (favorite) {
              store.dispatch(UpdateFavorites(toRemove: title));
              _animationController.stop();
              _animationController.forward();
            } else {
              store.dispatch(UpdateFavorites(toAdd: title));
              _animationController.repeat(
                  min: 0.8, max: 1.0, period: Duration(milliseconds: 500));
            }
          },
          tooltip: Constants.textTooltipFav,
        ),
      ),
    );
  }
}
