import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/FavoritesTap.dart';
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

  AnimationController _scaleController;
  AnimationController _heartController;
  Animation<double> _scale;
  Animation<double> _heartScale;
  bool _favorite;

  @override
  void initState() {
    super.initState();
    _scaleController = new AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _heartController = new AnimationController(
        duration: Duration(milliseconds: 500), vsync: this);

    _scale =
    new CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut);
    _heartScale =
    new CurvedAnimation(parent: _heartController, curve: Curves.easeInOut);

    _scaleController.forward();
    _heartController.value = 1.0;
    Future.delayed(Duration(milliseconds: 1200), () =>
        _heartController.notifyStatusListeners(AnimationStatus.completed));
  }

  @override
  void dispose() {
    _heartController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _favorite = store.state.favoritesSet.any((string) => string.contains(text));
    if (_favorite) {
      _heartController.notifyStatusListeners(AnimationStatus.completed);
    }
    _heartScale.addStatusListener((status) {
      if (_favorite) {
        if (status == AnimationStatus.completed) {
          _heartController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _heartController.forward();
        }
      } else {
        _heartController.animateTo(1.0);
      }
    });
    return ScaleTransition(
      scale: _scale,
      child: BlurOverlay(
        enabled: BlurSettingsParser(blurSettings: store.state.blurSettings)
            .getButtonsBlur(),
        radius: 100,
        intensity: 0.65,
        child: FloatingActionButton(
          backgroundColor: _favorite
              ? Theme
              .of(context)
              .backgroundColor
              .withAlpha(120)
              : Theme
              .of(context)
              .accentColor
              .withAlpha(120),
          child: ScaleTransition(
            scale: _favorite
                ? Tween(begin: 0.7, end: 1.3).animate(_heartScale)
                : Tween(
                begin: Tween(begin: 0.7, end: 1.3)
                    .animate(_heartScale)
                    .value,
                end: 1.0)
                .animate(_heartScale),
            child: Icon(Icons.favorite,
                color: _favorite ? Colors.red : Theme
                    .of(context)
                    .primaryColor),
          ),
          onPressed: () {
            FavoritesTap(store: store, text: text).onTap();
          },
          tooltip: Constants.textTooltipFav,
        ),
      ),
    );
  }
}
