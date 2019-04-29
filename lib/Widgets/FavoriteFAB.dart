import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/FirestoreSlideshowView.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class FavoriteFAB extends StatefulWidget {
  final Store store;
  final String title;
  final String id;

  FavoriteFAB({@required this.store, @required this.title, @required this.id});

  createState() => FavoriteFABState(store: store, text: title + ';' + id);
}

class FavoriteFABState extends State<FavoriteFAB>
    with TickerProviderStateMixin {
  FavoriteFABState({
    @required this.store,
    @required this.text,
  });

  final Store<AppStateMain> store;
  final String text;

  AnimationController _animationController;
  Animation<double> _scale;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _scale = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool favorite = store.state.favoritesSet.any((string) =>
        string.contains(text));
    if (favorite) {
      Future.delayed(Duration(milliseconds: 1200)).then((val) =>
      _disposed ? null : _animationController.repeat(
          min: 0.7, max: 1.0, period: Duration(milliseconds: 500)));
    }

    return ScaleTransition(
      scale: _scale,
      child: BlurOverlay(
        enabled: BlurSettings(store: store).getButtonsBlur(),
        radius: 100,
        intensity: 0.65,
        child: FloatingActionButton(
          backgroundColor: favorite
              ? Theme
              .of(context)
              .backgroundColor
              .withAlpha(120)
              : Theme
              .of(context)
              .accentColor
              .withAlpha(120),
          child: new Icon(Icons.favorite,
              color: favorite ? Colors.red : Theme.of(context).primaryColor),
          onPressed: () {
            if (text.split(';')[1].split('/')[1] !=
                Constants.textNoTextAvailable['id']) {
              final idx = TextSlideshowState.slideList.indexWhere((map) {
                return map['id'] == text.split(';')[1].split('/')[1];
              });
              if (favorite) {
                final int current = TextSlideshowState
                    .slideList[idx]['favorites'] ?? 1;
                TextSlideshowState.slideList[idx]['favorites'] =
                current == 0 ? 0 : current - 1;
                store.dispatch(UpdateFavorites(toRemove: text));
                _animationController.stop();
                _animationController.forward();
              } else {
                final int current = TextSlideshowState
                    .slideList[idx]['favorites'] ?? 0;
                TextSlideshowState.slideList[idx]['favorites'] =
                current == -1 ? 1 : current + 1;
                store.dispatch(UpdateFavorites(toAdd: text));
                _animationController.repeat(
                    min: 0.7, max: 1.0, period: Duration(milliseconds: 500));
              }
            }
          },
          tooltip: Constants.textTooltipFav,
        ),
      ),
    );
  }
}
