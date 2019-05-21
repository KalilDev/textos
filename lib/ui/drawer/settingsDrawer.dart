import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/aboutCreatorView.dart';

class SettingsDrawer extends StatefulWidget {
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  bool isChoosingAccent = false;

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
          onChanged: MediaQuery
              .of(context)
              .platformBrightness ==
                  Brightness.dark
              ? null
              : (map) => Provider.of<ThemeProvider>(context).toggleDarkMode()),
      ListTile(
        leading: Icon(Icons.color_lens),
        title: Text(Constants.textPickAccent, style: settingsStyle),
        onTap: () => setState(() => isChoosingAccent = true),
      ),
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
                DecreaseButton(value: Provider
                    .of<TextSizeProvider>(context)
                    .textSize,
                  onDecrease: () =>
                      Provider.of<TextSizeProvider>(context).decrease(),),
                IncreaseButton(value: Provider
                    .of<TextSizeProvider>(context)
                    .textSize,
                  onIncrease: () =>
                      Provider.of<TextSizeProvider>(context).increase(),),
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
          final List providerList = [
            Provider.of<FavoritesProvider>(context),
            Provider.of<ThemeProvider>(context),
            Provider.of<BlurProvider>(context),
            Provider.of<TextSizeProvider>(context),
          ];
          Navigator.pop(context);
          HapticFeedback.selectionClick();
          final result = await Navigator.push(
            context,
            SlideRoute(
                builder: (context) =>
                    CreatorView(
                      favoritesProvider: providerList[0].copy(),
                      darkModeProvider: providerList[1].copy(),
                      blurProvider: providerList[2].copy(),
                      textSizeProvider: providerList[3].copy(),
                    )),
          );
          List resultList = result;
          providerList[0].sync(resultList[0]);
          providerList[1].sync(resultList[1]);
          providerList[2].sync(resultList[2]);
          providerList[3].sync(resultList[3]);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete_forever),
        title: Text(Constants.textTextTrash, style: settingsStyle),
        onTap: () => cleanAll(context),
      ),
    ];
  }

  Widget buildCategory(List<Widget> children, {bool isBlurred}) {
    List<Widget> spacedChildren = [];
    spacedChildren.add(Divider());
    spacedChildren.addAll(children);
    return AnimatedSwitcher(
        duration: Constants.durationAnimationMedium,
        switchOutCurve: Curves.easeInOut,
        switchInCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) =>
            ScaleTransition(
              scale: Tween(begin: 0.7, end: 1.0).animate(animation),
              child: FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              ),
            ),
        child: isBlurred
            ? Column(children: spacedChildren)
            : ElevatedContainer(
            elevation: 4.0,
            margin: EdgeInsets.fromLTRB(3, 6, 3, 3),
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Material(
                color: Colors.transparent,
                child: Column(children: children),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final isBlurred = Provider
        .of<BlurProvider>(context)
        .drawerBlur;
    return SafeArea(
      child: isChoosingAccent
          ? LayoutBuilder(
          builder: (context, constraints) =>
              Container(
                  height: constraints.maxHeight,
                  child: SwatchesPicker(onChanged: (color) {
                    setState(() => isChoosingAccent = false);
                    Provider
                        .of<ThemeProvider>(context)
                        .accentColor = color;
                  })))
          : ListView(
        children: <Widget>[
          buildCategory(themeWidgets(), isBlurred: isBlurred),
          buildCategory(textWidgets(), isBlurred: isBlurred),
          buildCategory(favoriteWidgets(), isBlurred: isBlurred),
          buildCategory(blurWidgets(), isBlurred: isBlurred),
          buildCategory(miscWidgets(), isBlurred: isBlurred),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
