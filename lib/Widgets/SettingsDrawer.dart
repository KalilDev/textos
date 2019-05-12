import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:textos/Widgets/Widgets.dart';

class SettingsDrawer extends StatelessWidget {
  void cleanAll(BuildContext context) {
    Provider.of<FavoritesProvider>(context).clear();
    Provider.of<BlurProvider>(context).clearSettings();
    Provider.of<DarkModeProvider>(context).reset();
    Provider.of<TextSizeProvider>(context).reset();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    final TextStyle description =
    settingsStyle.copyWith(color: settingsStyle.color.withAlpha(190));
    return Column(
      children: <Widget>[
        Divider(),
        Text(Constants.textTema, style: description),
        SwitchListTile(
            title: Text(Constants.textTextTheme, style: settingsStyle),
            secondary: Icon(Icons.color_lens),
            value: Provider
                .of<DarkModeProvider>(context)
                .isDarkMode
                ? true
                : MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark
                ? true
                : false,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor: Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            inactiveThumbImage:
            MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark
                ? AssetImage('res/baseline_lock_white_96dp.png')
                : null,
            onChanged:
            MediaQuery
                .of(context)
                .platformBrightness == Brightness.dark
                ? null
                : (map) => Provider.of<DarkModeProvider>(context).toggle()),
        Divider(),
        Text(Constants.textText, style: description),
        ListTile(
            leading: Icon(Icons.text_fields),
            title: Text(Constants.textTextSize, style: settingsStyle),
            trailing: new Container(
              width: 96,
              child: Row(
                children: <Widget>[
                  TextDecrease(),
                  TextIncrease(),
                ],
              ),
            )),
        Divider(),
        Text(Constants.textFavs, style: description),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text(Constants.textCleanFavs, style: settingsStyle),
          onTap: () => Provider.of<FavoritesProvider>(context).clear(),
        ),
        Divider(),
        Text(Constants.textBlur, style: description),
        SwitchListTile(
            title: Text(Constants.textTextBlurDrawer, style: settingsStyle),
            secondary: Icon(Icons.blur_linear),
            value: Provider
                .of<BlurProvider>(context)
                .drawerBlur,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor: Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (map) =>
                Provider.of<BlurProvider>(context).toggleDrawerBlur()),
        SwitchListTile(
            title: Text(Constants.textTextBlurButtons, style: settingsStyle),
            secondary: Icon(Icons.blur_circular),
            value: Provider
                .of<BlurProvider>(context)
                .buttonsBlur,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor: Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (map) =>
                Provider.of<BlurProvider>(context).toggleButtonsBlur()),
        SwitchListTile(
            title: Text(Constants.textTextBlurText, style: settingsStyle),
            secondary: Icon(Icons.blur_on),
            value: Provider
                .of<BlurProvider>(context)
                .textsBlur,
            activeColor: Theme
                .of(context)
                .accentColor,
            activeTrackColor: Theme
                .of(context)
                .accentColor
                .withAlpha(170),
            onChanged: (map) =>
                Provider.of<BlurProvider>(context).toggleTextsBlur()),
        Divider(),
        Spacer(),
        ListTile(
          leading: Icon(Icons.delete_forever),
          title: Text(Constants.textTextTrash, style: settingsStyle),
          onTap: () => cleanAll(context),
        ),
        SizedBox(height: 50)
      ],
    );
  }
}
