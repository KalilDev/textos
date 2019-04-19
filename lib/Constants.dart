import 'package:flutter/material.dart';


class Constants {
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
  static const textTextSize = 'Tamanho do texto';
  static const textTextTheme = 'Tema Escuro';
  static const textTextTrash = 'Limpar favoritos';
  static const textTooltipTextSizeLess = 'Diminuir tamanho do texto';
  static const textTooltipTextSizePlus = 'Aumentar tamanho do texto';
  static const textTooltipFav = 'Adicionar aos favoritos';

  // Theme Light
  static const themeBackgroundLight = Colors.white;
  static const themeForegroundLight = Colors.black;
  static final themeDataLight = ThemeData(
      accentColor: themeAccent,
      scaffoldBackgroundColor: themeBackgroundLight,
      canvasColor: Colors.transparent,
      dividerColor: themeForegroundLight.withAlpha(70),
      primaryColor: themeForegroundLight,
      backgroundColor: themeBackgroundLight);

  // Theme Dark
  static const themeBackgroundDark = Colors.black;
  static const themeForegroundDark = Colors.white;
  static final themeDataDark = ThemeData(
      accentColor: themeAccent,
      scaffoldBackgroundColor: themeBackgroundDark,
      canvasColor: Colors.transparent,
      dividerColor: themeForegroundDark.withAlpha(70),
      primaryColor: themeForegroundDark,
      backgroundColor: themeBackgroundDark);

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
  static const placeholderImg = 'https://i.imgur.com/95fvCBU.jpg';

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
