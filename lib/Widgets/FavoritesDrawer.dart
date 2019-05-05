import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/FavoritesTap.dart';

class FavoritesDrawer extends StatelessWidget {
  final double textSize;
  final Set<String> favoriteSet;
  final int author;
  final FavoritesTap tapHandler;

  FavoritesDrawer({@required this.textSize,
    @required this.favoriteSet,
    @required this.author,
    @required this.tapHandler});

  Widget buildFavoritesItem(BuildContext context, String favorite) {
    final favoriteTitle = favorite.split(';')[0];

    Widget txt;
    if (favoriteTitle.length > 25) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Constants().textstyleTitle(textSize),
              blankSpace: 15,
              velocity: 35.0),
          height: 50.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Constants().textstyleTitle(textSize),
      );
    }
    return Dismissible(
        key: Key('Dismissible-' + favoriteTitle),
        background: Container(
          child: Row(
            children: <Widget>[
              Container(child: Icon(Icons.delete), width: 90),
              Spacer()
            ],
          ),
        ),
        secondaryBackground: Container(
          child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                child: Icon(Icons.delete),
                width: 90,
              ),
            ],
          ),
        ),
        onDismissed: (direction) => tapHandler.remove(favorite),
        child: ListTile(
            title: txt,
            onTap: () {
              tapHandler.open(favorite, context);
            }));
  }

  @override
  Widget build(BuildContext context) {
    List<String> favorites = [];
    favoriteSet.forEach((string) {
      if (string.contains(Constants.authorCollections[author])) {
        favorites.add(string);
      }
    });
    return new ListView.separated(
      itemCount: favorites.length,
      itemBuilder: (BuildContext context, int index) =>
          buildFavoritesItem(context, favorites[index]),
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}
