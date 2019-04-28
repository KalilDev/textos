import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/SettingsHelper.dart';
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

  @override
  initState() {
    super.initState();
    _animationController = new AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: BlurOverlay(
        enabled: BlurSettings(store).getButtonsBlur(),
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
