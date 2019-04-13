import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/FirestoreSlideshowView.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/TextCardView.dart';
import 'package:textos/main.dart';


class TextAppDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  TextAppDrawer({@required this.store});

  Widget buildFavoritesItem(BuildContext context, int index) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    final favoriteTitle = store.state.favoritesSet.toList()[index];
    final dataList = TextSlideshowState.slideList;

    var idxTxt = dataList.indexWhere((list) => list['title'] == favoriteTitle);

    Widget txt;
    if (favoriteTitle.length > 25) {
      txt = Container(
          child: Marquee(
              text: favoriteTitle,
              style: Constants().textstyleTitle(
                  store.state.textSize, store.state.enableDarkMode),
              blankSpace: Constants().reactiveSize(15, 1, height, width),
              velocity: 35.0),
          height: 50.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Constants().textstyleTitle(
            store.state.textSize, store.state.enableDarkMode),
      );
    }
    return ListTile(
        title: txt,
        onTap: () {
          if (idxTxt != -1) {
            TextSlideshowState.ctrl.jumpToPage(idxTxt + 1);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  new TextCard(map: dataList[idxTxt], store: store)),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget separator() {
      return Divider();
    }

    return new Drawer(
      child: Column(
        children: <Widget>[
          Center(
              child: Text(
                Constants.textFavs,
                style: Constants().textstyleText(
                    store.state.textSize, store.state.enableDarkMode),
              )),
          Expanded(
            child: ListView.separated(
                itemCount: store.state.favoritesSet.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildFavoritesItem(context, index),
                separatorBuilder: (BuildContext context, int index) =>
                    separator()),
          ),
          DrawerSettings(store: store).header(),
          DrawerSettings(store: store),
        ],
      ),
    );
  }
}
