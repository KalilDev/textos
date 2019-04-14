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
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.color_lens,
            color: Theme
                .of(context)
                .primaryColor,
          ),
          onPressed: () {
            store.dispatch(UpdateDarkMode(enable: !store.state.enableDarkMode));
          },
          iconSize: 25,
          tooltip: Constants.textTooltipTheme,
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.delete_forever,
            color: Theme
                .of(context)
                .primaryColor,
          ),
          onPressed: () {
            store.dispatch(UpdateFavorites(toClear: 1));
          },
          iconSize: 25,
          tooltip: Constants.textTooltipTrash,
        ),
        Spacer(),
        TextDecrease(store: store, isBackground: false),
        TextIncrease(store: store, isBackground: false),
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
    final themeBackground = Theme
        .of(context)
        .backgroundColor;
    final favorite = store.state.favoritesSet.toList().contains(title);

    return FloatingActionButton(
        backgroundColor: favorite
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
        },
      tooltip: Constants.textTooltipFav,);
  }
}

class TextIncrease extends StatelessWidget {
  const TextIncrease({
    Key key,
    @required this.store,
    @required this.isBackground,
  }) : super(key: key);

  final Store<AppStateMain> store;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isBackground) {
      color = Theme
          .of(context)
          .backgroundColor;
    } else {
      color = Theme
          .of(context)
          .primaryColor;
    }

    return IconButton(
      icon: Icon(
        Icons.arrow_upward,
        color: color,
      ),
      onPressed: () {
        if (store.state.textSize < 6.4) {
          store.dispatch(UpdateTextSize(size: store.state.textSize + 0.5));
        }
      },
      iconSize: 25,
      tooltip: Constants.textTooltipTextSizePlus,
    );
  }
}

class TextDecrease extends StatelessWidget {
  const TextDecrease({
    Key key,
    @required this.store,
    @required this.isBackground,
  }) : super(key: key);

  final Store<AppStateMain> store;
  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    Color color;
    if (isBackground) {
      color = Theme
          .of(context)
          .backgroundColor;
    } else {
      color = Theme
          .of(context)
          .primaryColor;
    }

    return IconButton(
      icon: Icon(
        Icons.arrow_downward,
        color: color,
      ),
      onPressed: () {
        if (store.state.textSize > 3.1) {
          store.dispatch(UpdateTextSize(size: store.state.textSize - 0.5));
        }
      },
      iconSize: 25,
      tooltip: Constants.textTooltipTextSizeLess,
    );
  }
}
