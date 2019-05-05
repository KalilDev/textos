import 'dart:math';

import 'package:flutter/material.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Widgets/Widgets.dart';

class FavoritesCount extends StatelessWidget {
  FavoritesCount({Key key,
    @required this.favorites,
    @required this.text,
    @required this.isFavorite,
    @required this.blurEnabled,
    @required this.favoritesTap,
    @required this.textSize})
      : super(key: key);

  final int favorites;
  final String text;
  final bool isFavorite;
  final bool blurEnabled;
  final Function favoritesTap;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlurOverlay(
          enabled: blurEnabled,
          radius: 90,
          color: Colors.red.withAlpha(110),
          child: FloatingActionButton.extended(
            heroTag: Random(),
            onPressed: () => favoritesTap(),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(favorites.toString() + ' ' + Constants.textFavs,
                style: Constants().textstyleTitle(textSize * 0.8)),
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(height: 25.0)
      ],
    );
  }
}
