import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:textos/constants.dart';

class IncDecButton extends StatefulWidget {
  final bool isBlurred;
  final double value;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  IncDecButton(
      {@required this.isBlurred, @required this.value, @required this.onIncrease, @required this.onDecrease});

  createState() => IncDecButtonState();
}

class IncDecButtonState extends State<IncDecButton>
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
      child: Material(
        color: Colors.transparent,
        elevation: 16.0,
        child: BlurOverlay(
          enabled: widget.isBlurred,
          radius: 80,
          child: Material(
            color: widget.isBlurred
                ? Theme
                .of(context)
                .accentColor
                .withAlpha(150)
                : Theme
                .of(context)
                .accentColor,
            child: Row(children: <Widget>[
              DecreaseButton(
                  value: widget.value, onDecrease: widget.onDecrease),
              IncreaseButton(
                  value: widget.value, onIncrease: widget.onIncrease),
            ]),
          ),
        ),
      ),
    );
  }
}

class IncreaseButton extends StatefulWidget {
  final double value;
  final VoidCallback onIncrease;

  IncreaseButton({@required this.value, @required this.onIncrease});
  @override
  _IncreaseButtonState createState() => _IncreaseButtonState();
}

class _IncreaseButtonState extends State<IncreaseButton>
    with TickerProviderStateMixin {
  double oldValue;
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
    oldValue = widget.value;
    _plusController.value = 1.0;
  }

  @override
  void dispose() {
    _plusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (oldValue != widget.value) {
      oldValue = widget.value;
      if (oldValue < widget.value) _plusController.reverse();
    }
    return ScaleTransition(
        child: IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: widget.onIncrease,
          tooltip: Constants.textTooltipTextSizePlus,
        ),
        scale: Tween(begin: 1.3, end: 1.0).animate(_plus));
  }
}

class DecreaseButton extends StatefulWidget {
  final double value;
  final VoidCallback onDecrease;

  DecreaseButton({@required this.value, @required this.onDecrease});
  @override
  _DecreaseButtonState createState() => _DecreaseButtonState();
}

class _DecreaseButtonState extends State<DecreaseButton>
    with TickerProviderStateMixin {
  double oldValue;
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
    oldValue = widget.value;
    _minusController.value = 1.0;
  }

  @override
  void dispose() {
    _minusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (oldValue != widget.value) {
      oldValue = widget.value;
      if (oldValue > widget.value) _minusController.reverse();
    }
    return ScaleTransition(
        child: IconButton(
          icon: Icon(
            Icons.arrow_downward,
          ),
          onPressed: widget.onDecrease,
          tooltip: Constants.textTooltipTextSizeLess,
        ),
        scale: Tween(begin: 0.7, end: 1.0).animate(_minus));
  }
}
