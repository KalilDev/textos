import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/widgets.dart';

class FavoritesDrawer extends StatelessWidget {
  Widget buildFavoritesItem(BuildContext context, String favorite) {
    final favoriteTitle = favorite.split(';')[0];

    Widget txt;
    if (favoriteTitle.length > 20) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Theme
                  .of(context)
                  .textTheme
                  .display2,
              blankSpace: 25,
              pauseAfterRound: Duration(seconds: 1),
              velocity: 60.0),
          height: 50.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Theme
            .of(context)
            .textTheme
            .display2,
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
        onDismissed: (direction) =>
            Provider.of<FavoritesProvider>(context).remove(favorite),
        child: ListTile(
            title: txt,
            onTap: () {
              Provider.of<FavoritesProvider>(context).open(favorite, context);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new ListView.separated(
        itemCount:
        Provider
            .of<FavoritesProvider>(context)
            .favoritesList
            .length + 1,
        itemBuilder: (BuildContext context, int index) =>
        index == 0
            ? Divider()
            : buildFavoritesItem(context,
            Provider
                .of<FavoritesProvider>(context)
                .favoritesList[index - 1]),
        separatorBuilder: (BuildContext context, int index) =>
        index == 0 ? NullWidget() : Divider(),
      ),
    );
  }
}
