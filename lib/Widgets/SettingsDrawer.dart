import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/BlurSettingsTap.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class SettingsDrawer extends StatelessWidget {
  final Store<AppStateMain> store;

  SettingsDrawer({@required this.store});

  @override
  Widget build(BuildContext context) {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    return Column(
      children: <Widget>[
        SwitchListTile(
            title: Text(Constants.textTextTheme, style: settingsStyle),
            secondary: Icon(Icons.color_lens),
            value: store.state.enableDarkMode ? true : MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark ? true : false,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor:
            Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            inactiveThumbImage: AssetImage('res/baseline_lock_white_96dp.png'),
            onChanged: MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark ? null
                : (map) =>
                store.dispatch(
                    UpdateDarkMode(
                        enable: !store.state.enableDarkMode))),
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
            title: Text(Constants.textTextBlurDrawer,
                style: settingsStyle),
            secondary: Icon(Icons.blur_linear),
            value: BlurSettings(store.state.blurSettings).drawerBlur,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor:
            Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (map) =>
                BlurSettingsTap(store: store).setDrawerBlur()),
        SwitchListTile(
            title: Text(Constants.textTextBlurButtons,
                style: settingsStyle),
            secondary: Icon(Icons.blur_circular),
            value: BlurSettings(store.state.blurSettings).buttonsBlur,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor:
            Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (map) =>
                BlurSettingsTap(store: store).setButtonsBlur()),
        SwitchListTile(
            title:
            Text(Constants.textTextBlurText, style: settingsStyle),
            secondary: Icon(Icons.blur_on),
            value: BlurSettings(store.state.blurSettings).textsBlur,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor:
            Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (map) =>
                BlurSettingsTap(store: store).setTextsBlur()),
      ],
    );
  }
}
