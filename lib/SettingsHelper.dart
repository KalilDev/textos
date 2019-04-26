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
    final favorite = store.state.favoritesSet.toList().contains(title);

    return BlurOverlay(
      enabled: BlurSettings(store).getButtonsBlur(),
      radius: 100,
      child: FloatingActionButton(
        backgroundColor: favorite
            ? Theme
            .of(context)
            .backgroundColor
            .withAlpha(160)
            : Theme
            .of(context)
            .accentColor
            .withAlpha(140),
        child: new Icon(Icons.favorite,
            color: favorite ? Colors.red : Theme
                .of(context)
                .primaryColor),
        onPressed: () {
          if (favorite) {
            store.dispatch(UpdateFavorites(toRemove: title));
          } else {
            store.dispatch(UpdateFavorites(toAdd: title));
          }
        },
        tooltip: Constants.textTooltipFav,
      ),
    );
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
    return IconButton(
      icon: Icon(
          Icons.arrow_upward
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
    return IconButton(
      icon: Icon(
        Icons.arrow_downward,
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

class SettingsDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  SettingsDrawer({@required this.store});

  @override
  Widget build(BuildContext context) {
    final TextStyle settingsStyle = Constants().textstyleTitle(
        store.state.textSize / 16 * 7);
    return Column(
      children: <Widget>[
        SwitchListTile(
            title: Text(Constants.textTextTheme, style: settingsStyle),
            secondary: Icon(Icons.color_lens),
            value: store.state.enableDarkMode,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor: Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (Map) =>
                store.dispatch(
                    UpdateDarkMode(enable: !store.state.enableDarkMode))),

      ListTile(
          leading: Icon(Icons.text_fields),
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
        leading: Icon(Icons.delete_forever),
        title: Text(Constants.textTextTrash, style: settingsStyle),
        onTap: () => store.dispatch(UpdateFavorites(toClear: 1)),
      ),
      SwitchListTile(
          title: Text(Constants.textTextBlurDrawer, style: settingsStyle),
          secondary: Icon(Icons.blur_linear),
          value: BlurSettings(store).getDrawerBlur(),
          activeColor: Theme
              .of(context)
              .accentColor,
          activeTrackColor: Theme
              .of(context)
              .accentColor
              .withAlpha(170),
          onChanged: (Map) =>
              BlurSettings(store).setDrawerBlur()),
      SwitchListTile(
          title: Text(Constants.textTextBlurButtons, style: settingsStyle),
          secondary: Icon(Icons.blur_circular),
          value: BlurSettings(store).getButtonsBlur(),
          activeColor: Theme
              .of(context)
              .accentColor,
          activeTrackColor: Theme
              .of(context)
              .accentColor
              .withAlpha(170),
          onChanged: (Map) =>
              BlurSettings(store).setButtonsBlur()),
      SwitchListTile(
          title: Text(Constants.textTextBlurText, style: settingsStyle),
          secondary: Icon(Icons.blur_on),
          value: BlurSettings(store).getTextsBlur(),
          activeColor: Theme
              .of(context)
              .accentColor,
          activeTrackColor: Theme
              .of(context)
              .accentColor
              .withAlpha(170),
          onChanged: (Map) =>
              BlurSettings(store).setTextsBlur()),
      ],
    );
  }
}

class BlurSettings {
  Store<AppStateMain> store;

  BlurSettings(@required this.store);

  List<double> settingsTable = [2.0, 3.0, 5.0];

  bool getDrawerBlur() {
    // Return true if drawer blur is enabled
    return store.state.blurSettings % settingsTable[0] == 0;
  }

  void setDrawerBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble = getDrawerBlur()
        ? currentSettings / settingsTable[0]
        : currentSettings * settingsTable[0];
    print(currentSettings.toString() + ' ' + settingsDouble.toString());
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }

  bool getButtonsBlur() {
    return store.state.blurSettings % settingsTable[1] == 0;
  }

  void setButtonsBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble = getButtonsBlur() ? currentSettings /
        settingsTable[1] : currentSettings * settingsTable[1];
    print(currentSettings.toString() + ' ' + settingsDouble.toString());
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }

  bool getTextsBlur() {
    return store.state.blurSettings % settingsTable[2] == 0;
  }

  void setTextsBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble = getTextsBlur()
        ? currentSettings / settingsTable[2]
        : currentSettings * settingsTable[2];
    print(currentSettings.toString() + ' ' + settingsDouble.toString());
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }
}

class BlurOverlay extends StatelessWidget {
  final Widget child;
  final int radius;
  final bool enabled;

  BlurOverlay({@required this.child, this.radius = 0, @required this.enabled});

  Widget blur(BuildContext context) {
    if (enabled) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
              color: Theme
                  .of(context)
                  .backgroundColor
                  .withAlpha(140),
              child: child));
    } else {
      return Container(
          color: Theme
              .of(context)
              .backgroundColor
              .withAlpha(200),
          child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (radius) {
      case 0 :
        return ClipRect(
            clipBehavior: Clip.hardEdge,
            child: blur(context));
        break;
      case 100 :
        return ClipOval(
            clipBehavior: Clip.hardEdge,
            child: blur(context));
        break;
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(radius.toDouble()),
        clipBehavior: Clip.hardEdge,
        child: blur(context));
  }
}
