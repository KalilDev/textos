import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
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
  AnimationController _minusController;
  AnimationController _plusController;
  Animation<double> _scale;
  Animation<double> _minus;
  Animation<double> _plus;
  double _textSize;

  @override
  initState() {
    super.initState();
    _textSize = store.state.textSize;
    _animationController = new AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _scale = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();

    _minusController = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _plusController = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _minus =
    new CurvedAnimation(parent: _minusController, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _minusController.forward();
        }
      });
    _plus =
    new CurvedAnimation(parent: _plusController, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _plusController.forward();
        }
      });
    _minusController.value = 1.0;
    _plusController.value = 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _minusController.dispose();
    _plusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textSize > store.state.textSize) {
      _minusController.reverse();
      print('I should be animating');
    } else if (_textSize < store.state.textSize) {
      _plusController.reverse();
      print('I should be animating');
    }
    _textSize = store.state.textSize;
    return ScaleTransition(
      scale: _scale,
      child: BlurOverlay(
        enabled: BlurSettingsParser(blurSettings: store.state.blurSettings)
            .getButtonsBlur(),
        radius: 80,
        intensity: 0.65,
        child: Material(
          color: Theme
              .of(context)
              .accentColor
              .withAlpha(120),
          child: Row(children: <Widget>[
            ScaleTransition(child: TextDecrease(store: store),
                scale: Tween(begin: 0.7, end: 1.0).animate(_minus)),
            ScaleTransition(child: TextIncrease(store: store),
                scale: Tween(begin: 1.3, end: 1.0).animate(_plus)),
          ]),
        ),
      ),
    );
  }
}

class TextIncrease extends StatelessWidget {
  const TextIncrease({
    Key key,
    @required this.store,
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_upward),
      onPressed: () {
        if (store.state.textSize < 6.4) {
          store.dispatch(UpdateTextSize(size: store.state.textSize + 0.5));
        }
      },
      iconSize: 25,
      tooltip: Constants.textTooltipTextSizePlus,
    );
  }
}

class TextDecrease extends StatelessWidget {
  const TextDecrease({
    Key key,
    @required this.store,
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_downward,
      ),
      onPressed: () {
        if (store.state.textSize > 3.1) {
          store.dispatch(UpdateTextSize(size: store.state.textSize - 0.5));
        }
      },
      iconSize: 25,
      tooltip: Constants.textTooltipTextSizeLess,
    );
  }
}
