import 'package:flutter/material.dart';


class Constants {
  final appHeight = 900;
  var appWidth;

  double reactiveSize(int size, int arg, double height, double width) {
    if (arg == 0) { //  height
      return size * height / appHeight;
    } else {
      appWidth = appHeight * width / height;
      return size * width / appWidth;
      //return appHeight * size * width * width / height;
    }
  }

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
  static const textConfigs = 'Configurações';
  static const textFavs = 'Favoritos';
  static const textTooltipTheme = 'Alterar tema';
  static const textTooltipTrash = 'Limpar favoritos';
  static const textTooltipTextSizeLess = 'Diminuir tamanho do texto';
  static const textTooltipTextSizePlus = 'Aumentar tamanho do texto';
  static const textTooltipFav = 'Favoritar textos';

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

  static double textInt;

  TextStyle textstyleTitle(double size) =>
      TextStyle(
          fontSize: size * 8,
          fontWeight: FontWeight.bold,
          color: themeForeground,
          fontFamily: 'Merriweather');

  TextStyle textstyleFilter(double size) =>
      TextStyle(
          fontSize: size * 3,
          color: themeForeground.withAlpha(150),
          fontFamily: 'Merriweather');

  TextStyle textstyleText(double size) =>
      TextStyle(fontSize: size * 4.5,
          color: themeForeground,
          fontFamily: 'Muli');

  TextStyle textstyleDate(double size) =>
      TextStyle(
          fontSize: size * 5,
          color: themeForeground,
          fontFamily: 'Merriweather');

  TextStyle textStyleButton(double size) =>
      TextStyle(
          fontSize: size * 3,
          color: themeForeground,
          fontFamily: 'Merriweather'
      );

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
