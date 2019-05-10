import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/TextSizeTap.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextSizeButton extends StatefulWidget {
  final Store store;

  TextSizeButton({@required this.store});

  createState() => TextSizeButtonState(store: store);
}

class TextSizeButtonState extends State<TextSizeButton>
    with TickerProviderStateMixin {
  TextSizeButtonState({
    @required this.store,
  });

  final Store<AppStateMain> store;

  AnimationController _animationController;
  Animation<double> _scale;
  double _textSize;

  @override
  initState() {
    super.initState();
    _textSize = store.state.textSize;
    _animationController = new AnimationController(
        duration: Constants.durationAnimationMedium +
            Constants.durationAnimationRoute,
        vsync: this);
    _scale = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut);
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
    _textSize = store.state.textSize;
    return ScaleTransition(
      scale: Tween(begin: animationStart, end: 1.0).animate(_scale),
      child: BlurOverlay(
        enabled: BlurSettings(store.state.blurSettings).buttonsBlur,
        radius: 80,
        intensity: 0.65,
        child: Material(
          color: Theme
              .of(context)
              .accentColor
              .withAlpha(120),
          child: Row(children: <Widget>[
            TextDecrease(store: store),
            TextIncrease(store: store),
          ]),
        ),
      ),
    );
  }
}

class TextIncrease extends StatefulWidget {
  const TextIncrease({
    Key key,
    @required this.store,
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  _TextIncreaseState createState() => _TextIncreaseState();
}

class _TextIncreaseState extends State<TextIncrease>
    with TickerProviderStateMixin {
  AnimationController _plusController;
  Animation<double> _plus;
  double _textSize;

  @override
  initState() {
    super.initState();
    _textSize = widget.store.state.textSize;

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
    if (_textSize < widget.store.state.textSize) {
      _plusController.reverse();
    }
    _textSize = widget.store.state.textSize;
    return ScaleTransition(
        child: IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: () {
            TextSizeTap(store: widget.store).increase();
          },
          iconSize: 25,
          tooltip: Constants.textTooltipTextSizePlus,
        ),
        scale: Tween(begin: 1.3, end: 1.0).animate(_plus));
  }
}

class TextDecrease extends StatefulWidget {
  const TextDecrease({
    Key key,
    @required this.store,
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  _TextDecreaseState createState() => _TextDecreaseState();
}

class _TextDecreaseState extends State<TextDecrease>
    with TickerProviderStateMixin {
  AnimationController _minusController;
  Animation<double> _minus;
  double _textSize;

  @override
  initState() {
    super.initState();
    _textSize = widget.store.state.textSize;

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
    if (_textSize > widget.store.state.textSize) {
      _minusController.reverse();
    }
    _textSize = widget.store.state.textSize;
    return ScaleTransition(
        child: IconButton(
          icon: Icon(
            Icons.arrow_downward,
          ),
          onPressed: () {
            TextSizeTap(store: widget.store).decrease();
          },
          iconSize: 25,
          tooltip: Constants.textTooltipTextSizeLess,
        ),
        scale: Tween(begin: 0.7, end: 1.0).animate(_minus));
  }
}
