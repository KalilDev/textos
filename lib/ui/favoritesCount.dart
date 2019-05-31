import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';

class FavoritesCount extends StatelessWidget {
  FavoritesCount({Key key,
    @required this.favorites,
    @required this.text,
    @required this.blurEnabled})
      : super(key: key);

  final int favorites;
  final String text;
  final bool blurEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          elevation: 16.0,
          child: BlurOverlay.roundedRect(
            enabled: blurEnabled,
            radius: 80,
            color: Colors.transparent,
            child: Consumer<FavoritesProvider>(
              builder: (BuildContext context, FavoritesProvider provider, _) =>
                  AnimatedGradientContainer(
                    colors: blurEnabled
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
                    isEnabled: provider.isFavorite(text),
                    height: 50,
                    child: RaisedButton(
                        elevation: 0.0,
                        highlightElevation: 0.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(width: 16.0),
                            Icon(
                                provider.isFavorite(text)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onSecondary),
                            const SizedBox(width: 8.0),
                            Text(favorites.toString() + ' ' + textFavs,
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
                        onPressed: () =>
                            Provider.of<FavoritesProvider>(context)
                                .toggle(text)),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 25.0)
      ],
    );
  }
}
