import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/text_icons_icons.dart';
import 'package:textos/ui/aboutCreatorView.dart';

class SettingsView extends StatelessWidget {
  void cleanAll(BuildContext context) {
    HapticFeedback.heavyImpact();
    Provider.of<FavoritesProvider>(context).clear();
    Provider.of<BlurProvider>(context).clearSettings();
    Provider.of<ThemeProvider>(context).reset();
    Provider.of<TextStyleProvider>(context).reset();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle styleSettings = Theme.of(context).textTheme.subhead;
    final TextStyle styleDescription = styleSettings.copyWith(
        color: getTextColor(0.87,
            main: Theme.of(context).colorScheme.onBackground,
            bg: Theme.of(context).colorScheme.background));

    Future<void> _openAbout() async {
      HapticFeedback.heavyImpact();
      Navigator.push(
        context,
        DurationMaterialPageRoute<void>(
            builder: (BuildContext context) => const CreatorView()),
      );
    }

    List<Widget> themeWidgets() {
      return <Widget>[
        Text(textTema, style: styleDescription),
        SwitchListTile(
            title: Text(textDarkTheme, style: styleSettings),
            secondary: const Icon(TextIcons.theme_light_dark),
            value: Provider.of<ThemeProvider>(context).isDarkMode
                ? true
                : MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? true
                    : false,
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withAlpha(170),
            inactiveThumbImage:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? const AssetImage('res/baseline_lock_white_96dp.png')
                    : null,
            onChanged:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? null
                    : (bool map) =>
                        Provider.of<ThemeProvider>(context).toggleDarkMode()),
        ListTile(
          leading: const Icon(Icons.style),
          title: Text('Alterar tema', style: styleSettings),
          onTap: () => Provider.of<ThemeProvider>(context).changeTheme(),
        ),
      ];
    }

    List<Widget> textWidgets() {
      return <Widget>[
        Text(textText, style: styleDescription),
        ListTile(
            leading: const Icon(TextIcons.format_size),
            title: Text(textTextSize, style: styleSettings),
            trailing: Container(
              width: 96,
              child: Row(
                children: <Widget>[
                  DecreaseButton(
                    value: Provider.of<TextStyleProvider>(context).textSize,
                    onDecrease: () =>
                        Provider.of<TextStyleProvider>(context).decrease(),
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  IncreaseButton(
                    value: Provider.of<TextStyleProvider>(context).textSize,
                    onIncrease: () =>
                        Provider.of<TextStyleProvider>(context).increase(),
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
              ),
            )),
        ListTile(
            leading: const Icon(Icons.short_text),
            title: Text(textTextAlignment, style: styleSettings),
            trailing: Container(
              width: 192,
              child: Row(
                children: <Widget>[
                  IconButton(tooltip: textTooltipAlignLeft, icon: const Icon(TextIcons.format_align_left), onPressed: () => Provider.of<TextStyleProvider>(context).textAlign = TextAlign.left),
                  IconButton(tooltip: textTooltipAlignCenter, icon: const Icon(TextIcons.format_align_center), onPressed: () => Provider.of<TextStyleProvider>(context).textAlign = TextAlign.center),
                  IconButton(tooltip: textTooltipAlignRight, icon: const Icon(TextIcons.format_align_right), onPressed: () => Provider.of<TextStyleProvider>(context).textAlign = TextAlign.right),
                  IconButton(tooltip: textTooltipAlignJustify, icon: const Icon(TextIcons.format_align_justify), onPressed: () => Provider.of<TextStyleProvider>(context).textAlign = TextAlign.justify),
                ],
              ),
            )),
      ];
    }

    List<Widget> favoriteWidgets() {
      return <Widget>[
        Text(textFavs, style: styleDescription),
        ListTile(
          leading: const Icon(TextIcons.notification_clear_all),
          title: Text(textCleanFavs, style: styleSettings),
          onTap: () => Provider.of<FavoritesProvider>(context).clear(),
        ),
      ];
    }

    List<Widget> blurWidgets() {
      return <Widget>[
        Text(textBlur, style: styleDescription),
        SwitchListTile(
            title: Text(textBlurButtons, style: styleSettings),
            secondary: const Icon(Icons.blur_circular),
            value: Provider.of<BlurProvider>(context).buttonsBlur,
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withAlpha(170),
            onChanged: (bool map) =>
                Provider.of<BlurProvider>(context).toggleButtonsBlur()),
        SwitchListTile(
            title: Text(textBlurText, style: styleSettings),
            secondary: const Icon(Icons.blur_on),
            value: Provider.of<BlurProvider>(context).textsBlur,
            activeColor: Theme.of(context).primaryColor,
            activeTrackColor: Theme.of(context).primaryColor.withAlpha(170),
            onChanged: (bool map) =>
                Provider.of<BlurProvider>(context).toggleTextsBlur()),
      ];
    }

    List<Widget> miscWidgets() {
      return <Widget>[
        Text(textMisc, style: styleDescription),
        Hero(
          tag: 'about',
          child: Material(
            color: Colors.transparent,
            elevation: 0.0,
            child: ListTile(
              leading: const Icon(TextIcons.information_variant),
              title: Text(
                'Sobre o criador',
                style: styleSettings,
              ),
              onTap: _openAbout,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(TextIcons.vanish),
          title: Text(textRestore, style: styleSettings),
          onTap: () => cleanAll(context),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text(textLogout, style: styleSettings),
          onTap: () {
            Provider.of<FavoritesProvider>(context).logout();
            Provider.of<AuthService>(context).logout();
          },
        ),
      ];
    }

    Widget buildCategory(List<Widget> children, {bool isFirst = false}) {
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

    return Container(
      decoration: BoxDecoration(
          color: Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(80),
              Theme.of(context).backgroundColor)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildCategory(themeWidgets(), isFirst: true),
            buildCategory(textWidgets()),
            buildCategory(favoriteWidgets()),
            buildCategory(blurWidgets()),
            buildCategory(miscWidgets()),
            const SizedBox(height: 56.0),
          ],
        ),
      ),
    );
  }
}
