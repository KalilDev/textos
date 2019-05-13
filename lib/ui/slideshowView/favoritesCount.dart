import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/widgets.dart';

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
        BlurOverlay(
          enabled: blurEnabled,
          radius: 90,
          color: Colors.transparent,
          child: Consumer<FavoritesProvider>(
            builder: (context, provider, _) =>
                AnimatedGradientContainer(
                  colors: <Color>[
                    Colors.red.shade900.withAlpha(180),
                    Colors.indigo.shade400.withAlpha(150)
                  ],
                  isEnabled: provider.isFavorite(text),
                  height: 50,
                  child: RaisedButton(
                      elevation: 6.0,
                      highlightElevation: 14.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 16.0),
                          Icon(provider.isFavorite(text)
                              ? Icons.favorite
                              : Icons.favorite_border),
                          const SizedBox(width: 8.0),
                          Text(favorites.toString() + ' ' + Constants.textFavs,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .title),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                      color: Colors.transparent,
                      onPressed: () =>
                          Provider.of<FavoritesProvider>(context).toggle(text)),
                ),
          ),
        ),
        SizedBox(height: 25.0)
      ],
    );
  }
}
