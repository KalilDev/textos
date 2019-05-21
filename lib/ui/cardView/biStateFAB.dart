import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:textos/constants.dart';

class BiStateFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isBlurred;
  final bool isEnabled;
  final List<IconData> icons;

  BiStateFAB(
      {@required this.onPressed, @required this.isBlurred, @required this.isEnabled, IconData enabledIcon, IconData disabledIcon})
      : this.icons = [
    (enabledIcon != null) ? enabledIcon : Icons.favorite,
    (disabledIcon != null) ? disabledIcon : Icons.favorite_border
  ];

  createState() => _BiStateFABState();
}

class _BiStateFABState extends State<BiStateFAB>
    with TickerProviderStateMixin {

  AnimationController _scaleController;
  AnimationController _iconController;
  Animation<double> _scale;
  Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _scaleController = new AnimationController(
        duration: Constants.durationAnimationRoute +
            Constants.durationAnimationMedium,
        vsync: this);
    _iconController = new AnimationController(
        duration: Constants.durationAnimationMedium, vsync: this);

    _scale =
        Tween(begin: animationStart, end: 1.0).animate(
            CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
    _iconScale =
    new CurvedAnimation(parent: _iconController, curve: Curves.easeInOut);

    _scaleController.forward();
    _iconController.value = 1.0;
    Future.delayed(
        Constants.durationAnimationRoute + Constants.durationAnimationMedium,
            () =>
            _iconController.notifyStatusListeners(AnimationStatus.completed));
  }

  @override
  void dispose() {
    _iconController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  double get animationStart =>
      0 -
          (Constants.durationAnimationRoute.inMilliseconds /
          Constants.durationAnimationMedium.inMilliseconds);

  @override
  Widget build(BuildContext context) {
    if (widget.isEnabled) {
      _iconController.notifyStatusListeners(AnimationStatus.completed);
    }
    _iconScale.addStatusListener((status) {
      if (widget.isEnabled) {
        if (status == AnimationStatus.completed) {
          _iconController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _iconController.forward();
        }
      } else {
        _iconController.animateTo(1.0);
      }
    });
    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        elevation: 16.0,
        child: BlurOverlay(
          enabled: widget.isBlurred,
          radius: 100,
          child: AnimatedGradientContainer(
            colors: widget.isBlurred ? <Color>[
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
            isEnabled: widget.isEnabled,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: ScaleTransition(
                scale: widget.isEnabled
                    ? Tween(begin: 0.7, end: 1.3).animate(_iconScale)
                    : Tween(
                    begin: Tween(begin: 0.7, end: 1.3)
                        .animate(_iconScale)
                        .value,
                    end: 1.0)
                    .animate(_iconScale),
                child: Icon(
                    widget.isEnabled ? widget.icons[0] : widget.icons[1],
                    color:
                    widget.isEnabled ? Colors.red : Theme
                        .of(context)
                        .primaryColor),
              ),
              onPressed: widget.onPressed,
              tooltip: Constants.textTooltipFav,
            ),
          ),
        ),
      ),
    );
  }
}
