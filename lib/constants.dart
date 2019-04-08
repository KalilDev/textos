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
  static final themeDataLight = ThemeData(accentColor: themeAccent);

  // Theme Dark
  static const themeBackgroundDark = Colors.black;
  static const themeForegroundDark = Colors.white;
  static final themeDataDark = ThemeData(
      accentColor: themeAccent,
      scaffoldBackgroundColor: themeBackgroundDark,
      canvasColor: themeBackgroundDark);

  // Themes
  static const themeAccent = Colors.indigo;
  static var themeBackground = themeBackgroundLight;
  static var themeForeground = themeForegroundLight;
  static var themeData = themeDataLight;

  // TextStyles
  static var textstyleTitle = TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: themeForeground,
      fontFamily: 'Merriweather');
  static var textstyleFilter = TextStyle(
      color: themeForeground.withAlpha(150), fontFamily: 'Merriweather');
  static var textstyleStoryTitle =
      textstyleTitle.copyWith(color: themeBackground);
  static var textstyleText =
      TextStyle(fontSize: 20, color: themeBackground, fontFamily: 'Muli');
  static var textstyleDate = TextStyle(
      fontSize: 25, color: themeBackground, fontFamily: 'Merriweather');

  // Placeholders
  static const placeholderTitle = 'Titulo';
  static const placeholderText = 'Texto';
  static const placeholderDate = '01/01/1970';
  static const placeholderImg = 'https://i.imgur.com/H6i4c32.jpg';
}
