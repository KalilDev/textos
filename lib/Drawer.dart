import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    return Drawer(child: BlurOverlay(
        enabled: BlurSettings(store).getDrawerBlur(), child: Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery
              .of(context)
              .padding
              .top,
        ),
        Center(
            child: Text(
              store.state.settingsDrawer ? Constants.textConfigs : Constants
                  .textFavs,
              style: Constants()
                  .textstyleText(
                  store.state.textSize, store.state.enableDarkMode),
            )),
        store.state.settingsDrawer
            ? Column(
          children: SettingsDrawer(store: store, context: context).drawer(),)
            : Expanded(child: FavoritesDrawer(store: store).drawer(context)),
        Spacer(),
        ListTile(title: Text(
          store.state.settingsDrawer ? Constants.textFavs : Constants
              .textConfigs, style: Constants()
            .textstyleTitle(
            store.state.textSize / 16 * 9, store.state.enableDarkMode),
          textAlign: TextAlign.center,), onTap: () {
          store.dispatch(
              UpdateSettingsBool(boolean: !store.state.settingsDrawer));
        },)
      ],
    )));
  }
}

class FavoritesDrawer {
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
              style: Constants().textstyleTitle(
                  store.state.textSize, store.state.enableDarkMode),
              blankSpace: 15,
              velocity: 35.0),
          height: 50.0);
    } else {
      txt = Text(
        favoriteTitle,
        style: Constants()
            .textstyleTitle(store.state.textSize, store.state.enableDarkMode),
      );
    }
    return Dismissible(
        key: Key('Dismissible-' + favoriteTitle),
        background: Container(child: Row(
          children: <Widget>[
            Container(child: Icon(Icons.delete, color: Theme
                .of(context)
                .primaryColor,), width: 90), Spacer()
          ],
        ),),
        secondaryBackground: Container(child: Row(
          children: <Widget>[
            Spacer(), Container(
              child: Icon(Icons.delete, color: Theme
                  .of(context)
                  .primaryColor), width: 90,),
          ],
        ),),
        onDismissed: (direction) =>
        {store.dispatch(UpdateFavorites(toRemove: favoriteTitle))}
    ,
    child
        :
    ListTile
    (
    title
        :
    txt
    ,
    onTap
        :
    (
    )
    {
    if (idxTxt != -1)
    {
    TextSlideshowState.ctrl.jumpToPage(idxTxt + 1);
    Navigator.pop(context);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    TextCard(map: dataList[idxTxt], store: store)),
    );
    }
    }
    )
    ,
    );
  }

  Widget drawer(BuildContext context) {
    return new ListView.separated(
      itemCount: store.state.favoritesSet.length,
      itemBuilder: (BuildContext context, int index) =>
          buildFavoritesItem(context, index),
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}


class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
      color: Theme
          .of(context)
          .primaryColor,);
  }
}