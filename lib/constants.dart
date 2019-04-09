import 'package:flutter/material.dart';

class Constants {
  void changeTheme() {
    themeBackground = themeBackground == themeBackgroundDark
        ? themeBackgroundLight
        : themeBackgroundDark;
    themeForeground = themeForeground == themeForegroundDark
        ? themeForegroundLight
        : themeForegroundDark;
    themeData = themeData == themeDataDark ? themeDataLight : themeDataDark;
  }

  // Text
  static const textKalil = 'do Kalil';
  static const textTextos = 'Textos ';
  static const textFilter = 'FILTRO';
  static const List<String> textTag = [
    'Todos',
    'Crônicas',
    'Reflexões',
    'Desabafos'
  ];
  static const textTema = 'Tema';

  // Theme Light
  static const themeBackgroundLight = Colors.white;
  static const themeForegroundLight = Colors.black;
  static final themeDataLight = ThemeData(accentColor: themeAccent,
      dividerColor: themeForegroundLight.withAlpha(70));

  // Theme Dark
  static const themeBackgroundDark = Colors.black;
  static const themeForegroundDark = Colors.white;
  static final themeDataDark = ThemeData(
      accentColor: themeAccent,
      scaffoldBackgroundColor: themeBackgroundDark,
      canvasColor: themeBackgroundDark,
      dividerColor: themeForegroundDark.withAlpha(70));

  // Themes
  static const themeAccent = Colors.indigo;
  static var themeBackground;
  static var themeForeground;
  static var themeData;

  void setDarkTheme() {
    themeBackground = themeBackgroundDark;
    themeForeground = themeForegroundDark;
    themeData = themeDataDark;
  }

  void setWhiteTheme() {
    themeBackground = themeBackgroundLight;
    themeForeground = themeForegroundLight;
    themeData = themeDataLight;
  }

  // TextStyles
  TextStyle textstyleTitle() =>
      TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: themeForeground,
      fontFamily: 'Merriweather');

  TextStyle textstyleFilter() =>
      TextStyle(
      color: themeForeground.withAlpha(150), fontFamily: 'Merriweather');

  TextStyle textstyleText() =>
      TextStyle(fontSize: 20, color: themeForeground, fontFamily: 'Muli');

  TextStyle textstyleDate() =>
      TextStyle(
          fontSize: 25, color: themeForeground, fontFamily: 'Merriweather');

  // Placeholders
  static const placeholderTitle = 'Titulo';
  static const placeholderText = 'Texto';
  static const placeholderDate = '01/01/1970';
  static const placeholderImg = 'https://i.imgur.com/H6i4c32.jpg';

  // AppBar
  Widget appbarTransparent() => AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    iconTheme: IconThemeData(color: Constants.themeForeground),
    key: Key('appbar'),);
}
