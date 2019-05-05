import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/FavoritesTap.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class FavoritesCount extends StatelessWidget {
  FavoritesCount({
    Key key,
    @required this.favorites,
    @required this.store,
    @required this.text}) : super(key: key);

  final Store<AppStateMain> store;
  final int favorites;
  final String text;

  bool _isFavorite;

  @override
  Widget build(BuildContext context) {
    _isFavorite = store.state.favoritesSet.any((favorite) => favorite == text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlurOverlay(
          enabled: BlurSettingsParser(blurSettings: store.state.blurSettings)
              .getTextsBlur(),
          radius: 90,
          color: Colors.red.withAlpha(110),
          child: FloatingActionButton.extended(
            heroTag: Random(),
            onPressed: () => FavoritesTap(store: store).toggle(text),
            icon: _isFavorite ? Icon(Icons.favorite) : Icon(
                Icons.favorite_border),
            label: Text(favorites.toString() + ' ' + Constants.textFavs,
                style: Constants().textstyleTitle(store.state.textSize * 0.8)),
            backgroundColor: Colors.transparent,),
        ),
        SizedBox(height: 5.0)
      ],
    );
  }
}
