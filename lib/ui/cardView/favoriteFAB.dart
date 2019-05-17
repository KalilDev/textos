import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/widgets.dart';

class FavoriteFAB extends StatefulWidget {
  final String title;
  final String path;

  FavoriteFAB({@required this.title, @required this.path});

  createState() => FavoriteFABState();
}

class FavoriteFABState extends State<FavoriteFAB>
    with TickerProviderStateMixin {
  String get text => (widget.title + ';' + widget.path);

  AnimationController _scaleController;
  AnimationController _heartController;
  Animation<double> _scale;
  Animation<double> _heartScale;
  bool _favorite;

  @override
  void initState() {
    super.initState();
    _scaleController = new AnimationController(
        duration: Constants.durationAnimationRoute +
            Constants.durationAnimationMedium,
        vsync: this);
    _heartController = new AnimationController(
        duration: Constants.durationAnimationMedium, vsync: this);

    _scale =
        Tween(begin: animationStart, end: 1.0).animate(
            CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
    _heartScale =
    new CurvedAnimation(parent: _heartController, curve: Curves.easeInOut);

    _scaleController.forward();
    _heartController.value = 1.0;
    Future.delayed(
        Constants.durationAnimationRoute + Constants.durationAnimationMedium,
            () =>
            _heartController.notifyStatusListeners(AnimationStatus.completed));
  }

  @override
  void dispose() {
    _heartController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  double get animationStart =>
      0 -
          (Constants.durationAnimationRoute.inMilliseconds /
          Constants.durationAnimationMedium.inMilliseconds);

  @override
  Widget build(BuildContext context) {
    _favorite = Provider.of<FavoritesProvider>(context).isFavorite(text);
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
      child: Material(
        color: Colors.transparent,
        elevation: 16.0,
        child: BlurOverlay(
          enabled: Provider
              .of<BlurProvider>(context)
              .buttonsBlur,
          radius: 100,
          child: AnimatedGradientContainer(
            colors: Provider
                .of<BlurProvider>(context)
                .buttonsBlur ? <Color>[
              Theme
                  .of(context)
                  .backgroundColor
                  .withAlpha(150),
              Theme
                  .of(context)
                  .accentColor
                  .withAlpha(150)
            ] : [Theme
                .of(context)
                .backgroundColor,
            Theme
                .of(context)
                .accentColor
            ],
            trueValues: [1.0, 2.0],
            falseValues: [-1.0, 0.0],
            isEnabled: _favorite,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: ScaleTransition(
                scale: _favorite
                    ? Tween(begin: 0.7, end: 1.3).animate(_heartScale)
                    : Tween(
                    begin: Tween(begin: 0.7, end: 1.3)
                        .animate(_heartScale)
                        .value,
                    end: 1.0)
                    .animate(_heartScale),
                child: Icon(_favorite ? Icons.favorite : Icons.favorite_border,
                    color:
                    _favorite ? Colors.red : Theme
                        .of(context)
                        .primaryColor),
              ),
              onPressed: () =>
                  Provider.of<FavoritesProvider>(context).toggle(text),
              tooltip: Constants.textTooltipFav,
            ),
          ),
        ),
      ),
    );
  }
}
