import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/mixins.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/aboutCreatorView.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with Haptic {
  TextStyle styleDescription;
  TextStyle styleSettings;

  void cleanAll(BuildContext context) {
    openView();
    Provider.of<FavoritesProvider>(context).clear();
    Provider.of<BlurProvider>(context).clearSettings();
    Provider.of<ThemeProvider>(context).reset();
    Provider.of<TextSizeProvider>(context).reset();
  }

  List<Widget> themeWidgets() {
    return <Widget>[
      Text(textTema, style: styleDescription),
      SwitchListTile(
          title: Text(textTextTheme, style: styleSettings),
          secondary: const Icon(Icons.invert_colors),
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
              ? const AssetImage('res/baseline_lock_white_96dp.png')
                  : null,
          onChanged:
          MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark
              ? null
              : (bool map) =>
              Provider.of<ThemeProvider>(context).toggleDarkMode()),
    ];
  }

  List<Widget> textWidgets() {
    return <Widget>[
      Text(textText, style: styleDescription),
      ListTile(
          leading: const Icon(Icons.text_fields),
          title: Text(textTextSize, style: styleSettings),
          trailing: Container(
            width: 96,
            child: Row(
              children: <Widget>[
                DecreaseButton(
                  value: Provider
                      .of<TextSizeProvider>(context)
                      .textSize,
                  onDecrease: () =>
                      Provider.of<TextSizeProvider>(context).decrease(),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onBackground,
                ),
                IncreaseButton(
                  value: Provider
                      .of<TextSizeProvider>(context)
                      .textSize,
                  onIncrease: () =>
                      Provider.of<TextSizeProvider>(context).increase(),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onBackground,
                ),
              ],
            ),
          )),
    ];
  }

  List<Widget> favoriteWidgets() {
    return <Widget>[
      Text(textFavs, style: styleDescription),
      ListTile(
        leading: const Icon(Icons.delete),
        title: Text(textCleanFavs, style: styleSettings),
        onTap: () => Provider.of<FavoritesProvider>(context).clear(),
      ),
    ];
  }

  List<Widget> blurWidgets() {
    return <Widget>[
      Text(textBlur, style: styleDescription),
      SwitchListTile(
          title: Text(textTextBlurButtons, style: styleSettings),
          secondary: const Icon(Icons.blur_circular),
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
          onChanged: (bool map) =>
              Provider.of<BlurProvider>(context).toggleButtonsBlur()),
      SwitchListTile(
          title: Text(textTextBlurText, style: styleSettings),
          secondary: const Icon(Icons.blur_on),
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
          onChanged: (bool map) =>
              Provider.of<BlurProvider>(context).toggleTextsBlur()),
    ];
  }

  List<Widget> miscWidgets() {
    return <Widget>[
      Text(textsMisc, style: styleDescription),
      ListTile(
        leading: const Icon(Icons.info),
        title: Text(
          'Sobre o criador',
          style: styleSettings,
        ),
        onTap: () async {
          Navigator.pop(context);
          openView();
          Navigator.push(
            context,
            SlideRoute<void>(
                builder: (BuildContext context) => const CreatorView()),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.delete_forever),
        title: Text(textTextTrash, style: styleSettings),
        onTap: () => cleanAll(context),
      ),
    ];
  }

  Widget buildCategory(List<Widget> children,
      {bool isBlurred, bool isFirst = false}) {
    return ElevatedContainer(
        elevation: 4.0,
        margin: isFirst
            ? const EdgeInsets.fromLTRB(3, 12.5, 3, 3)
            : const EdgeInsets.fromLTRB(3, 5, 3, 3),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
    final bool isBlurred = Provider
        .of<BlurProvider>(context)
        .drawerBlur;
    styleSettings = Theme
        .of(context)
        .textTheme
        .subhead;
    styleDescription = styleSettings.copyWith(
        color: getTextColor(0.87,
            main: Theme
                .of(context)
                .colorScheme
                .onBackground,
            bg: Theme
                .of(context)
                .colorScheme
                .background));
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
          const SizedBox(height: 40.0),
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
