import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/aboutCreatorView.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  void cleanAll(BuildContext context) {
    HapticFeedback.heavyImpact();
    Provider.of<FavoritesProvider>(context).clear();
    Provider.of<BlurProvider>(context).clearSettings();
    Provider.of<ThemeProvider>(context).reset();
    Provider.of<TextSizeProvider>(context).reset();
  }

  List<Widget> themeWidgets() {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    final TextStyle description =
    settingsStyle.copyWith(color: settingsStyle.color.withAlpha(190));

    return <Widget>[
      Text(Constants.textTema, style: description),
      SwitchListTile(
          title: Text(Constants.textTextTheme, style: settingsStyle),
          secondary: Icon(Icons.invert_colors),
          value: Provider
              .of<ThemeProvider>(context)
              .isDarkMode
              ? true
              : MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark
                  ? true
                  : false,
          activeColor: Theme
              .of(context)
              .primaryColor,
          activeTrackColor: Theme
              .of(context)
              .primaryColor
              .withAlpha(170),
          inactiveThumbImage:
          MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark
                  ? AssetImage('res/baseline_lock_white_96dp.png')
                  : null,
          onChanged: MediaQuery
              .of(context)
              .platformBrightness ==
                  Brightness.dark
              ? null
              : (map) => Provider.of<ThemeProvider>(context).toggleDarkMode()),
    ];
  }

  List<Widget> textWidgets() {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    final TextStyle description =
    settingsStyle.copyWith(color: settingsStyle.color.withAlpha(190));

    return <Widget>[
      Text(Constants.textText, style: description),
      ListTile(
          leading: Icon(Icons.text_fields),
          title: Text(Constants.textTextSize, style: settingsStyle),
          trailing: new Container(
            width: 96,
            child: Row(
              children: <Widget>[
                DecreaseButton(
                  value: Provider
                      .of<TextSizeProvider>(context)
                      .textSize,
                  onDecrease: () =>
                      Provider.of<TextSizeProvider>(context).decrease(),
                ),
                IncreaseButton(
                  value: Provider
                      .of<TextSizeProvider>(context)
                      .textSize,
                  onIncrease: () =>
                      Provider.of<TextSizeProvider>(context).increase(),
                ),
              ],
            ),
          )),
    ];
  }

  List<Widget> favoriteWidgets() {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    final TextStyle description =
    settingsStyle.copyWith(color: settingsStyle.color.withAlpha(190));

    return <Widget>[
      Text(Constants.textFavs, style: description),
      ListTile(
        leading: Icon(Icons.delete),
        title: Text(Constants.textCleanFavs, style: settingsStyle),
        onTap: () => Provider.of<FavoritesProvider>(context).clear(),
      ),
    ];
  }

  List<Widget> blurWidgets() {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    final TextStyle description =
    settingsStyle.copyWith(color: settingsStyle.color.withAlpha(190));

    return <Widget>[
      Text(Constants.textBlur, style: description),
      SwitchListTile(
          title: Text(Constants.textTextBlurDrawer, style: settingsStyle),
          secondary: Icon(Icons.blur_linear),
          value: Provider
              .of<BlurProvider>(context)
              .drawerBlur,
          activeColor: Theme
              .of(context)
              .primaryColor,
          activeTrackColor: Theme
              .of(context)
              .primaryColor
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
              .primaryColor,
          activeTrackColor: Theme
              .of(context)
              .primaryColor
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
              .primaryColor,
          activeTrackColor: Theme
              .of(context)
              .primaryColor
              .withAlpha(170),
          onChanged: (map) =>
              Provider.of<BlurProvider>(context).toggleTextsBlur()),
    ];
  }

  List<Widget> miscWidgets() {
    final TextStyle settingsStyle = Theme
        .of(context)
        .textTheme
        .subhead;
    final TextStyle description =
    settingsStyle.copyWith(color: settingsStyle.color.withAlpha(190));

    return <Widget>[
      Text(Constants.textsMisc, style: description),
      ListTile(
        leading: Icon(Icons.info),
        title: Text(
          'Sobre o criador',
          style: settingsStyle,
        ),
        onTap: () async {
          Navigator.pop(context);
          HapticFeedback.selectionClick();
          Navigator.push(
            context,
            SlideRoute(
                builder: (context) =>
                    CreatorView(
                      darkModeProvider: Provider.of<ThemeProvider>(context),
                    )),
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.delete_forever),
        title: Text(Constants.textTextTrash, style: settingsStyle),
        onTap: () => cleanAll(context),
      ),
    ];
  }

  Widget buildCategory(List<Widget> children,
      {bool isBlurred, bool isFirst = false}) {
    return ElevatedContainer(
        elevation: 4.0,
        margin: isFirst
            ? EdgeInsets.fromLTRB(3, 12.5, 3, 3)
            : EdgeInsets.fromLTRB(3, 5, 3, 3),
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Material(
            color: Colors.transparent,
            child: Column(children: children),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final isBlurred = Provider
        .of<BlurProvider>(context)
        .drawerBlur;
    return Container(
      decoration: BoxDecoration(
          color: Color.alphaBlend(Theme
              .of(context)
              .primaryColor
              .withAlpha(80),
              Theme
                  .of(context)
                  .backgroundColor)),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 40.0),
          buildCategory(themeWidgets(), isBlurred: isBlurred, isFirst: true),
          buildCategory(textWidgets(), isBlurred: isBlurred),
          buildCategory(favoriteWidgets(), isBlurred: isBlurred),
          buildCategory(blurWidgets(), isBlurred: isBlurred),
          buildCategory(miscWidgets(), isBlurred: isBlurred)
        ],
      ),
    );
  }
}
