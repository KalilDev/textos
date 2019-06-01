import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/text_icons_icons.dart';

import 'cardView.dart';

class FavoritesView extends StatelessWidget {
  Widget buildFavoritesItem(BuildContext context, String favorite) {
    final String favoriteTitle = favorite.split(';')[0];

    Widget txt;
    if (favoriteTitle.length > 30) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Theme.of(context).accentTextTheme.display1,
              blankSpace: 25,
              pauseAfterRound: const Duration(seconds: 1),
              velocity: 60.0),
          height: 60.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Theme.of(context).accentTextTheme.display1,
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
        child: RepaintBoundary(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                FutureBuilder<Content>(
                  future: Provider.of<FavoritesProvider>(context)
                      .getContent(favorite),
                  builder:
                      (BuildContext context, AsyncSnapshot<Content> snap) =>
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
                                    child: Hero(
                                      tag: 'body' +
                                          (snap.hasData
                                              ? snap.data.textPath
                                              : 'null'),
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 7.0),
                                          child: txt),
                                    ),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          DurationMaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  CardView(
                                                    textContent: snap.data,
                                                  )));
                                    }),
                              ),
                            ),
                          ),
                ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Provider.of<FavoritesProvider>(context).favoritesList.isNotEmpty
            ? ListView.builder(
                itemCount: Provider.of<FavoritesProvider>(context)
                    .favoritesList
                    .length,
                itemBuilder: (BuildContext context, int index) =>
                    buildFavoritesItem(
                        context,
                        Provider.of<FavoritesProvider>(context)
                            .favoritesList[index]),
              )
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    RepaintBoundary(
                        child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                          Container(
                              height: constraints.maxHeight,
                              child: Container(
                                  child: Center(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const <Widget>[
                                    Icon(TextIcons.heart_broken_outline,
                                        size: 72),
                                    Text(
                                      textNoFavs + '\n:(',
                                      textAlign: TextAlign.center,
                                    )
                                  ]))))
                        ]))));
  }
}
