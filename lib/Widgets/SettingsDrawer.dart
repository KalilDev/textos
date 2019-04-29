import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class SettingsDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  SettingsDrawer({@required this.store});

  @override
  Widget build(BuildContext context) {
    final TextStyle settingsStyle =
        Constants().textstyleTitle(store.state.textSize / 16 * 7);
    return Column(
      children: <Widget>[
        SwitchListTile(
            title: Text(Constants.textTextTheme, style: settingsStyle),
            secondary: Icon(Icons.color_lens),
            value: store.state.enableDarkMode,
            activeColor: Theme.of(context).accentColor,
            activeTrackColor: Theme.of(context).accentColor.withAlpha(170),
            onChanged: (map) =>
                store
                .dispatch(UpdateDarkMode(enable: !store.state.enableDarkMode))),
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
            value: BlurSettings(store: store).getDrawerBlur(),
            activeColor: Theme.of(context).accentColor,
            activeTrackColor: Theme.of(context).accentColor.withAlpha(170),
            onChanged: (map) => BlurSettings(store: store).setDrawerBlur()),
        SwitchListTile(
            title: Text(Constants.textTextBlurButtons, style: settingsStyle),
            secondary: Icon(Icons.blur_circular),
            value: BlurSettings(store: store).getButtonsBlur(),
            activeColor: Theme.of(context).accentColor,
            activeTrackColor: Theme.of(context).accentColor.withAlpha(170),
            onChanged: (map) => BlurSettings(store: store).setButtonsBlur()),
        SwitchListTile(
            title: Text(Constants.textTextBlurText, style: settingsStyle),
            secondary: Icon(Icons.blur_on),
            value: BlurSettings(store: store).getTextsBlur(),
            activeColor: Theme.of(context).accentColor,
            activeTrackColor: Theme.of(context).accentColor.withAlpha(170),
            onChanged: (map) => BlurSettings(store: store).setTextsBlur()),
      ],
    );
  }
}
