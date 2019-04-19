import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/main.dart';

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
    final themeForeground = Theme
        .of(context)
        .primaryColor;
    final favorite = store.state.favoritesSet.toList().contains(title);

    return ClipOval(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: FloatingActionButton(
              backgroundColor: favorite
                  ? themeBackground.withAlpha(160)
                  : Theme
                  .of(context)
                  .accentColor
                  .withAlpha(140),
              child: new Icon(Icons.favorite,
                  color: favorite ? Colors.red : themeForeground),
              onPressed: () {
                if (favorite) {
                  store.dispatch(UpdateFavorites(toRemove: title));
                } else {
                  store.dispatch(UpdateFavorites(toAdd: title));
                }
              },
              tooltip: Constants.textTooltipFav,
            )));
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
    Color color;
    color = Theme
        .of(context)
        .primaryColor;

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
  }) : super(key: key);

  final Store<AppStateMain> store;

  @override
  Widget build(BuildContext context) {
    Color color;
    color = Theme
        .of(context)
        .primaryColor;

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

class SettingsDrawer {
  final Store<AppStateMain> store;
  final BuildContext context;

  SettingsDrawer({@required this.store, @required this.context});

  List<Widget> drawer() {
    final TextStyle settingsStyle = Constants().textstyleTitle(
        store.state.textSize / 16 * 7, store.state.enableDarkMode);
    final Color settingsIconColor = Theme
        .of(context)
        .primaryColor;
    return [
      SwitchListTile(
          title: Text(Constants.textTextTheme, style: settingsStyle),
          secondary: Icon(Icons.color_lens, color: settingsIconColor),
          value: store.state.enableDarkMode,
          onChanged: (Map) =>
              store.dispatch(
                  UpdateDarkMode(enable: !store.state.enableDarkMode))),
      ListTile(
          leading: Icon(Icons.text_fields, color: settingsIconColor),
          title: Text(Constants.textTextSize, style: settingsStyle),
          trailing: new Container(
            width: 96,
            child: Row(
              children: <Widget>[
                TextDecrease(store: store),
                TextIncrease(store: store),
              ],
            ),
          )),
      ListTile(
        leading: Icon(Icons.delete_forever, color: settingsIconColor),
        title: Text(Constants.textTextTrash, style: settingsStyle),
        onTap: () => store.dispatch(UpdateFavorites(toClear: 1)),
      ),
    ];
  }
}

class BlurOverlay extends StatelessWidget {
  final Widget child;

  BlurOverlay({@required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
                color: Theme
                    .of(context)
                    .backgroundColor
                    .withAlpha(140),
                child: child)));
  }
}
