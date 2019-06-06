import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/model/favorite.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/text_icons_icons.dart';

import 'cardView.dart';
import 'textCard.dart';
class FavoritesView extends StatelessWidget {
  const FavoritesView({@required this.spacerSize});
  final double spacerSize;

  Widget buildFavoritesItem(BuildContext context, Favorite favorite) {
    return Dismissible(
        key: Key('Dismissible-' + favorite.textId),
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
                  builder: (BuildContext context,
                          AsyncSnapshot<Content> snap) => Container(height: 100.0,child: ContentCard.sliver(content: Content.fromFav(favorite), callBack: () async {
                    final Content data = snap.hasData
                        ? snap.data
                        : await Provider.of<FavoritesProvider>(
                        context)
                        .getContent(favorite);
                    HapticFeedback.heavyImpact();
                    Navigator.push(
                        context,
                        DurationMaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                CardView(
                                  content: data,
                                )));
                  },))
                ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Provider.of<FavoritesProvider>(context).favoritesSet.isNotEmpty
            ? ListView.separated(
                itemCount: Provider.of<FavoritesProvider>(context)
                        .favoritesSet
                        .length +
                    1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0)
                    return SizedBox(height: spacerSize);
                    return buildFavoritesItem(
                        context,
                        Provider.of<FavoritesProvider>(context)
                            .favoritesSet.elementAt(index - 1));
                },
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10.0,),)
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Container(
                        child: Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                          Icon(TextIcons.heart_broken_outline, size: 72),
                          Text(
                            textNoFavs + '\n:(',
                            textAlign: TextAlign.center,
                          )
                        ])))));
  }
}
