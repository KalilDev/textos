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
  const FavoritesView({@required this.spacerSize, @required this.isList});
  final double spacerSize;
  final bool isList;

  List<Widget> _childrenBuilder(Iterable<Favorite> favs) {
    List<Widget> list = <Widget>[];
    for (Favorite fav in favs) {
      list.add(_FavoriteItem(favorite: fav, key: Key('reorderableTile' + fav.textId)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Provider.of<FavoritesProvider>(context).favoritesSet.isNotEmpty
            ? ReorderableListView(
                children: _childrenBuilder(Provider.of<FavoritesProvider>(context).favoritesSet),
                padding: EdgeInsets.fromLTRB(4.0, spacerSize, 4.0, 4.0),
                onReorder: Provider.of<FavoritesProvider>(context).reorder)
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

class _FavoriteItem extends StatelessWidget {
  _FavoriteItem({Key key, @required this.favorite}) : super(key: key);
  final Favorite favorite;
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FutureBuilder<Content>(
                future: Provider.of<FavoritesProvider>(context)
                    .getContent(favorite),
                builder: (BuildContext context,
                    AsyncSnapshot<Content> snap) {
                  if (snap.hasData == false)
                    return Container();
                  return Container(margin: EdgeInsets.only(bottom: 12.0),height: 100.0,child: ContentCard.sliver(content: snap.data, callBack: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                      context,
                      DurationMaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              CardView(
                                content: snap.data,
                              )));
                },));
                }
            ),
    );
  }
}