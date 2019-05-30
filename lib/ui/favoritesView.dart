import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:textos/src/providers.dart';

class FavoritesView extends StatelessWidget {
  Widget buildFavoritesItem(BuildContext context, String favorite) {
    final String favoriteTitle = favorite.split(';')[0];

    Widget txt;
    if (favoriteTitle.length > 30) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Theme
                  .of(context)
                  .accentTextTheme
                  .display1,
              blankSpace: 25,
              pauseAfterRound: const Duration(seconds: 1),
              velocity: 60.0),
          height: 60.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Theme
            .of(context)
            .accentTextTheme
            .display1,
        textAlign: TextAlign.center,
      );
    }
    return Dismissible(
        key: Key('Dismissible-' + favoriteTitle),
        background: Container(
          child: Row(
            children: <Widget>[
              Container(child: const Icon(Icons.delete), width: 90),
              Spacer()
            ],
          ),
        ),
        secondaryBackground: Container(
          child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                child: const Icon(Icons.delete),
                width: 90,
              ),
            ],
          ),
        ),
        onDismissed: (DismissDirection direction) =>
            Provider.of<FavoritesProvider>(context).remove(favorite),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              ElevatedContainer(
                elevation: 4.0,
                width: constraints.maxWidth,
                margin: const EdgeInsets.fromLTRB(3, 6, 3, 3),
                borderRadius: BorderRadius.circular(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 7.0),
                            child: txt),
                        onTap: () {
                          Provider.of<FavoritesProvider>(context)
                              .open(favorite, context);
                        }),
                  ),
                ),
              ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: Provider
            .of<FavoritesProvider>(context)
            .favoritesList
            .length,
        itemBuilder: (BuildContext context, int index) =>
            buildFavoritesItem(
                context,
                Provider
                    .of<FavoritesProvider>(context)
                    .favoritesList[index]),
      ),
    );
  }
}
