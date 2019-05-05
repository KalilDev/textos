import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Views/FirestoreSlideshowView.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/main.dart';

class FavoritesDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  FavoritesDrawer({@required this.store});

  Widget buildFavoritesItem(BuildContext context, String favorite) {
    final favoriteTitle = favorite.split(
        ';')[0];
    final dataList = TextSlideshowState.slideList;

    var idxTxt = dataList.indexWhere((list) => list['title'] == favoriteTitle);

    Widget txt;
    if (favoriteTitle.length > 25) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Constants().textstyleTitle(store.state.textSize),
              blankSpace: 15,
              velocity: 35.0),
          height: 50.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Constants().textstyleTitle(store.state.textSize),
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
      {store.dispatch(UpdateFavorites(toRemove: favorite))}
    ,
      child: ListTile(
          title: txt,
          onTap: () {
            if (idxTxt != -1) {
              TextSlideshowState.ctrl.jumpToPage(idxTxt + 1);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
    TextCardView(data: dataList[idxTxt], store: store)),
              );
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allFavorites = store.state.favoritesSet;
    List<String> favorites = [];
    allFavorites.forEach((string) {
      if (string.contains(Constants.authorCollections[store.state.author])) {
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
