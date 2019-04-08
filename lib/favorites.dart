import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:textos/constants.dart';
import 'package:textos/main.dart';

class Favorites {
  var list = FirestoreSlideshowState.favorites;

  bool isFavorite(String id) {
    return list.contains(id);
  }

  void setFavorite(String id) {
    print(list);
    if (isFavorite(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
  }

  Set<String> getFavorites() {
    return list;
  }

  Widget buildItem(BuildContext context, int index) {
    final text = list.toList()[index];
    final idxTxt = FirestoreSlideshowState.all[text];
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
          FirestoreSlideshowState.ctrl.animateToPage(idxTxt,
              duration: Duration(milliseconds: 600), curve: Curves.decelerate);
          Navigator.pop(context);
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
      child: ListView.separated(
        itemCount: FirestoreSlideshowState.favorites.length,
        itemBuilder: (BuildContext context, int index) =>
            Favorites().buildItem(context, index),
        separatorBuilder: (BuildContext context, int index) => Separator(),
      ),
    );
  }
}
