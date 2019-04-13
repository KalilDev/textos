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

  static double textInt;

  TextStyle textstyleTitle(double size, bool isDark) =>
      TextStyle(
          fontSize: size * 8,
          fontWeight: FontWeight.bold,
          color: isDark
              ? themeForegroundDark
              : themeForegroundLight,
          fontFamily: 'Merriweather');

  TextStyle textstyleFilter(double size, bool isDark) =>
      TextStyle(
          fontSize: size * 3,
          color: isDark
              ? themeForegroundDark.withAlpha(150)
              : themeForegroundLight.withAlpha(150),
          fontFamily: 'Merriweather');

  TextStyle textstyleText(double size, bool isDark) =>
      TextStyle(fontSize: size * 4.5,
          color: isDark
              ? themeForegroundDark
              : themeForegroundLight,
          fontFamily: 'Muli');

  TextStyle textstyleDate(double size, bool isDark) =>
      TextStyle(
          fontSize: size * 5,
          color: isDark
              ? themeForegroundDark
              : themeForegroundLight,
        fontFamily: 'Merriweather',);

  TextStyle textStyleButton(double size, bool isDark) =>
      TextStyle(
          fontSize: size * 3,
          color: isDark
              ? themeForegroundDark
              : themeForegroundLight,
          fontFamily: 'Merriweather'
      );

  // Placeholders
  static const placeholderTitle = 'Titulo';
  static const placeholderText = 'Texto';
  static const placeholderDate = '01/01/1970';
  static const placeholderImg = 'https://i.imgur.com/H6i4c32.jpg';

  // AppBar
  Widget appbarTransparent(bool isDark) =>
      AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
        iconTheme: IconThemeData(color: isDark
            ? themeForegroundDark
            : themeForegroundLight,),
    key: Key('appbar'),);
}
