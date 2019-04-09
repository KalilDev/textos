import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/Settings.dart';
import 'package:textos/constants.dart';
import 'package:textos/individualView.dart';
import 'package:textos/slideshow.dart';

class Favorites {
  var list = FirestoreSlideshowState.favorites;

  bool isFavorite(String id) {
    return list.contains(id);
  }

  void updateFavorites() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('favorites', list.toList());
    });
  }

  void setFavorite(String id) {
    if (isFavorite(id)) {
      list.remove(id);
      updateFavorites();
    } else {
      list.add(id);
      updateFavorites();
    }
  }

  Set<String> getFavorites() {
    return list;
  }

  Widget buildItem(BuildContext context, int index) {
    final text = list.toList()[index];
    final dataList = FirestoreSlideshowState.slideList;

    var idxTxt = dataList.indexWhere((list) => list['title'] == text);

    Widget txt;
    if (text.length > 25) {
      txt = Container(
          child: Marquee(
              text: text,
              style: Constants().textstyleTitle(),
              blankSpace: 15.0,
              velocity: 35.0),
          height: 50.0);
    } else {
      txt = Text(
        text,
        style: Constants().textstyleTitle(),
      );
    }
    return ListTile(
        title: txt,
        onTap: () {
          if (idxTxt != -1) {
            FirestoreSlideshowState.ctrl.jumpToPage(idxTxt + 1);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TextCard(map: dataList[idxTxt])),
            );
          }
        });
  }
}

class FavoritesDrawer extends StatefulWidget {
  createState() => new FavoritesDrawerState();
}

class FavoritesDrawerState extends State<FavoritesDrawer> {
  @override
  Widget build(BuildContext context) {
    Widget Separator() {
      return Divider();
    }

    return new Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
                itemCount: FirestoreSlideshowState.favorites.length,
                itemBuilder: (BuildContext context, int index) =>
                    Favorites().buildItem(context, index),
                separatorBuilder: (BuildContext context, int index) =>
                    Separator()
            ),
          ),
          DrawerSettings().header(),
          DrawerSettings(),
        ],
      ),
    );
  }
}
