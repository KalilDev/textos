import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/main.dart';


class DrawerSettings extends StatelessWidget {
  final Store<AppStateMain> store;

  DrawerSettings({@required this.store});

  Widget header() {
    return Center(
        child: Text(
          Constants.textConfigs,
          style: Constants().textstyleText(
              store.state.textSize, store.state.enableDarkMode),
        ));
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.color_lens,
            color: store.state.enableDarkMode
                ? Constants.themeForegroundDark
                : Constants.themeForegroundLight,
          ),
          onPressed: () {
            store.dispatch(UpdateDarkMode(enable: !store.state.enableDarkMode));
          },
          iconSize: Constants().reactiveSize(25, 0, height, width),
          tooltip: Constants.textTooltipTheme,
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: store.state.enableDarkMode
                ? Constants.themeForegroundDark
                : Constants.themeForegroundLight,
          ),
          onPressed: () {
            store.dispatch(UpdateFavorites(toClear: 1));
          },
          iconSize: Constants().reactiveSize(25, 0, height, width),
          tooltip: Constants.textTooltipTrash,
        ),
        Spacer(),
        TextDecrease(store: store),
        TextIncrease(store: store),
      ],
    );
  }
}

class FavoriteFAB extends StatelessWidget {
  const FavoriteFAB({
    Key key,
    @required this.store,
    @required this.title,
  }) : super(key: key);

  final Store<AppStateMain> store;
  final String title;

  @override
  Widget build(BuildContext context) {
    final themeBackground = store.state.enableDarkMode ? Constants
        .themeBackgroundDark : Constants.themeBackgroundLight;
    final favorite = store.state.favoritesSet.toList().contains(title);
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return Container(
        width: Constants().reactiveSize(60, 0, height, width),
        height: Constants().reactiveSize(60, 0, height, width),
        margin: EdgeInsetsDirectional.only(
            top: Constants().reactiveSize(5, 0, height, width)),
        child: new RawMaterialButton(
            shape: new CircleBorder(),
            elevation: 0.0,
            fillColor: favorite
                ? themeBackground
                : Constants.themeAccent,
            child: new Icon(Icons.favorite,
                color: favorite ? Colors.red : themeBackground),
            onPressed: () {
              if (favorite) {
                store.dispatch(UpdateFavorites(toRemove: title));
              } else {
                store.dispatch(UpdateFavorites(toAdd: title));
              }
            }));
  }
}

class TextIncrease extends StatelessWidget {
  const TextIncrease({
    Key key,
    @required this.store,
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return IconButton(
      icon: Icon(
        Icons.arrow_upward,
        color: store.state.enableDarkMode
            ? Constants.themeForegroundDark
            : Constants.themeForegroundLight,
      ),
      onPressed: () {
        if (store.state.textSize < 6.4) {
          store.dispatch(UpdateTextSize(size: store.state.textSize + 0.5));
        }
      },
      iconSize: Constants().reactiveSize(25, 0, height, width),
      tooltip: Constants.textTooltipTextSizePlus,
    );
  }
}

class TextDecrease extends StatelessWidget {
  const TextDecrease({
    Key key,
    @required this.store,
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return IconButton(
      icon: Icon(
        Icons.arrow_downward,
        color: store.state.enableDarkMode
            ? Constants.themeForegroundDark
            : Constants.themeForegroundLight,
      ),
      onPressed: () {
        if (store.state.textSize > 3.1) {
          store.dispatch(UpdateTextSize(size: store.state.textSize - 0.5));
        }
      },
      iconSize: Constants().reactiveSize(25, 0, height, width),
      tooltip: Constants.textTooltipTextSizeLess,
    );
  }
}
