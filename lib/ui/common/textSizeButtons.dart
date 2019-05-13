import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/widgets.dart';

class TextSizeButton extends StatefulWidget {
  createState() => TextSizeButtonState();
}

class TextSizeButtonState extends State<TextSizeButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scale;

  @override
  initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: Constants.durationAnimationMedium +
            Constants.durationAnimationRoute,
        vsync: this);
    _scale = Tween(begin: animationStart, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get animationStart =>
      0 -
          (Constants.durationAnimationRoute.inMilliseconds /
          Constants.durationAnimationMedium.inMilliseconds);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Stack(
        children: <Widget>[
          BlurOverlay(
            enabled: Provider
                .of<BlurProvider>(context)
                .buttonsBlur,
            radius: 80,
            intensity: 0.65,
            child: IgnorePointer(
              child: Material(
                color: Theme
                    .of(context)
                    .accentColor
                    .withAlpha(120),
                child: Row(children: <Widget>[
                  SizedBox(height: 48,
                    width: 48,),
                  SizedBox(height: 48,
                    width: 48,)
                ]),
              ),
            ),
          ),
          Row(children: <Widget>[
            TextDecrease(),
            TextIncrease(),
          ]),
        ],
      ),
    );
  }
}

class TextIncrease extends StatefulWidget {
  @override
  _TextIncreaseState createState() => _TextIncreaseState();
}

class _TextIncreaseState extends State<TextIncrease>
    with TickerProviderStateMixin {
  AnimationController _plusController;
  Animation<double> _plus;

  @override
  initState() {
    super.initState();
    _plusController = new AnimationController(
        duration: Constants.durationAnimationMedium, vsync: this);
    _plus =
    new CurvedAnimation(parent: _plusController, curve: Curves.decelerate)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _plusController.forward();
        }
      });
    _plusController.value = 1.0;
  }

  @override
  void dispose() {
    _plusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider
        .of<TextSizeProvider>(context)
        .increased) {
      Provider
          .of<TextSizeProvider>(context)
          .increased = false;
      _plusController.reverse();
    }
    return ScaleTransition(
        child: IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () {
            Provider.of<TextSizeProvider>(context).increase();
          },
          tooltip: Constants.textTooltipTextSizePlus,
        ),
        scale: Tween(begin: 1.3, end: 1.0).animate(_plus));
  }
}

class TextDecrease extends StatefulWidget {
  @override
  _TextDecreaseState createState() => _TextDecreaseState();
}

class _TextDecreaseState extends State<TextDecrease>
    with TickerProviderStateMixin {
  AnimationController _minusController;
  Animation<double> _minus;

  @override
  initState() {
    super.initState();
    _minusController = new AnimationController(
        duration: Constants.durationAnimationMedium, vsync: this);
    _minus =
    new CurvedAnimation(parent: _minusController, curve: Curves.decelerate)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _minusController.forward();
        }
      });
    _minusController.value = 1.0;
  }

  @override
  void dispose() {
    _minusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider
        .of<TextSizeProvider>(context)
        .decreased) {
      Provider
          .of<TextSizeProvider>(context)
          .decreased = false;
      _minusController.reverse();
    }
    return ScaleTransition(
        child: IconButton(
          icon: Icon(
            Icons.arrow_downward,
          ),
          onPressed: () {
            Provider.of<TextSizeProvider>(context).decrease();
          },
          tooltip: Constants.textTooltipTextSizeLess,
        ),
        scale: Tween(begin: 0.7, end: 1.0).animate(_minus));
  }
}
