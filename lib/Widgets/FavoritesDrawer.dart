import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/FirestoreSlideshowView.dart';
import 'package:textos/TextCardView.dart';
import 'package:textos/main.dart';

class FavoritesDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  FavoritesDrawer({@required this.store});

  Widget buildFavoritesItem(BuildContext context, int index) {
    final favoriteTitle = store.state.favoritesSet.toList()[index];
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
          {store.dispatch(UpdateFavorites(toRemove: favoriteTitle))},
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
                        TextCardView(map: dataList[idxTxt], store: store)),
              );
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.separated(
      itemCount: store.state.favoritesSet.length,
      itemBuilder: (BuildContext context, int index) =>
          buildFavoritesItem(context, index),
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}
