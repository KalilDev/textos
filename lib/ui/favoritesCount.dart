import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:textos/constants.dart';

class ExpandedFABCounter extends StatelessWidget {
  ExpandedFABCounter({Key key,
    @required this.counter,
    @required this.isEnabled,
    @required this.isBlurred,
    this.onPressed})
      : super(key: key);

  final int counter;
  final bool isBlurred;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          elevation: 16.0,
          child: BlurOverlay.roundedRect(
            enabled: isBlurred,
            radius: 80,
            color: Colors.transparent,
            child: AnimatedGradientContainer(
              colors: isBlurred
                  ? <Color>[
                Theme
                    .of(context)
                    .colorScheme
                    .error
                    .withAlpha(180),
                Theme
                    .of(context)
                    .accentColor
                    .withAlpha(150)
              ]
                  : <Color>[
                Theme
                    .of(context)
                    .colorScheme
                    .error,
                Theme
                    .of(context)
                    .accentColor
              ],
              isEnabled: isEnabled,
              height: 50,
              child: RaisedButton(
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(width: 16.0),
                      Icon(
                          isEnabled
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSecondary),
                      const SizedBox(width: 8.0),
                      Text(counter.toString() + ' ' + textFavs,
                          style: Theme
                              .of(context)
                              .textTheme
                              .title
                              .copyWith(
                              color: getTextColor(0.87, bg: Theme
                                  .of(context)
                                  .colorScheme
                                  .background, main: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSecondary))),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                  color: Colors.transparent,
                  onPressed: onPressed),
            ),
          ),
        ),
        const SizedBox(height: 25.0)
      ],
    );
  }
}
