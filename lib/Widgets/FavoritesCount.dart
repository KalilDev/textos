import 'package:flutter/material.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Widgets/Widgets.dart';

class FavoritesCount extends StatelessWidget {
  FavoritesCount({Key key,
    @required this.favorites,
    @required this.text,
    @required this.isFavorite,
    @required this.blurEnabled,
    @required this.favoritesTap})
      : super(key: key);

  final int favorites;
  final String text;
  final bool isFavorite;
  final bool blurEnabled;
  final Function favoritesTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlurOverlay(
          enabled: blurEnabled,
          radius: 90,
          color: Colors.transparent,
          child: new AnimatedGradientContainer(
            colors: <Color>[Colors.red.shade900.withAlpha(180),
            Colors.indigo.shade400.withAlpha(150)
            ],
            isEnabled: isFavorite,
            height: 50,
            child: RaisedButton(
                elevation: 6.0,
                highlightElevation: 14.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(width: 16.0),
                    Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    const SizedBox(width: 8.0),
                    Text(favorites.toString() + ' ' + Constants.textFavs,
                        style: Theme
                            .of(context)
                            .textTheme
                            .title),
                    const SizedBox(width: 20.0),
                  ],),
                color: Colors.transparent,
                onPressed: () => favoritesTap()
            ),),
          ),
        SizedBox(height: 25.0)
      ],
    );
  }
}
