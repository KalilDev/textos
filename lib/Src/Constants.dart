import 'package:flutter/material.dart';

class Constants {
  // Text
  static const textTextos = 'Textos ';
  static const textFilter = 'FILTRO';
  static const textAllTag = 'Todos';
  static const textTema = 'Tema';
  static const textConfigs = 'Configurações';
  static const textFavs = 'Favoritos';
  static const textTextSize = 'Tamanho do texto';
  static const textTextTheme = 'Tema Escuro';
  static const textTextTrash = 'Restaurar o Padrão';
  static const textTextBlurDrawer = 'Borrar a gaveta';
  static const textTextBlurButtons = 'Borrar os botões';
  static const textTextBlurText = 'Borrar fundo dos textos';
  static const textTooltipTextSizeLess = 'Diminuir tamanho do texto';
  static const textTooltipTextSizePlus = 'Aumentar tamanho do texto';
  static const textTooltipFav = 'Adicionar aos favoritos';
  static const textTooltipDrawer = 'Abrir gaveta';
  static const textText = 'Texto';
  static const textCleanFavs = 'Limpar Favoritos';
  static const textBlur = 'Borrado';
  static final Map<String, dynamic> textNoTextAvailable = {
    'title': 'Não há nenhum texto nessa categoria',
    'img': 'https://i.imgur.com/yugoBNL.jpg',
    'text':
    'Nenhum texto foi encontrado nessa categoria, tente o seguinte: Desconecte e reconecte seu telefone à internet',
    'favoriteCount': 0,
    'date': DateTime
        .now()
        .day
        .toString() + '/' + DateTime
        .now()
        .month
        .toString() + '/' + DateTime
        .now()
        .year
        .toString(),
    'path': 'NULL/TEXTNOTFOUNDID'
  };

  // Theme Light
  static const themeBackgroundLight = Colors.white;
  static const themeForegroundLight = Colors.black;
  static final themeDataLight = ThemeData(
      brightness: Brightness.light,
      accentColor: themeAccent,
      accentColorBrightness: Brightness.light,
      scaffoldBackgroundColor: themeBackgroundLight,
      canvasColor: themeBackgroundLight,
      dividerColor: themeForegroundLight.withAlpha(70),
      primaryColor: themeForegroundLight,
      primaryColorBrightness: Brightness.dark,
      backgroundColor: themeBackgroundLight,
      accentTextTheme: textThemeMuli.apply(
          bodyColor: themeForegroundLight, displayColor: themeForegroundLight),
      textTheme: textThemeMerriweather.apply(
          bodyColor: themeForegroundLight, displayColor: themeForegroundLight));

  // Theme Dark
  static const themeBackgroundDark = Colors.black;
  static const themeForegroundDark = Colors.white;
  static final themeDataDark = ThemeData(
      brightness: Brightness.dark,
      accentColor: themeAccent,
      accentColorBrightness: Brightness.dark,
      scaffoldBackgroundColor: themeBackgroundDark,
      canvasColor: themeBackgroundDark,
      dividerColor: themeForegroundDark.withAlpha(70),
      primaryColor: themeForegroundDark,
      primaryColorBrightness: Brightness.light,
      backgroundColor: themeBackgroundDark,
      accentTextTheme: textThemeMuli.apply(
          bodyColor: themeForegroundDark, displayColor: themeForegroundDark),
      textTheme: textThemeMerriweather.apply(
          bodyColor: themeForegroundDark, displayColor: themeForegroundDark));

  // BaseTextStyles
  static final _baseTextStyleMuli = TextStyle(fontFamily: 'Muli');
  static final _baseTextStyleMerriweather =
  TextStyle(fontFamily: 'Merriweather');

  // TextTheme
  static final textThemeMuli = TextTheme(
    display4: _baseTextStyleMuli.copyWith(
        fontSize: 112.0, fontWeight: FontWeight.w100),
    display3: _baseTextStyleMuli.copyWith(
        fontSize: 56.0, fontWeight: FontWeight.w400),
    display2: _baseTextStyleMuli.copyWith(
        fontSize: 45.0, fontWeight: FontWeight.w400),
    display1: _baseTextStyleMuli.copyWith(
        fontSize: 34.0, fontWeight: FontWeight.w400),
    headline: _baseTextStyleMuli.copyWith(
        fontSize: 24.0, fontWeight: FontWeight.w400),
    title: _baseTextStyleMuli.copyWith(
        fontSize: 20.0, fontWeight: FontWeight.w500),
    subhead: _baseTextStyleMuli.copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w400),
    body2: _baseTextStyleMuli.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    body1: _baseTextStyleMuli.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w400),
    caption: _baseTextStyleMuli.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    button: _baseTextStyleMuli.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    subtitle: _baseTextStyleMuli.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    overline: _baseTextStyleMuli.copyWith(
        fontSize: 10.0, fontWeight: FontWeight.w400),
  );
  static final textThemeMerriweather = TextTheme(
    display4: _baseTextStyleMerriweather.copyWith(
        fontSize: 112.0, fontWeight: FontWeight.w100),
    display3: _baseTextStyleMerriweather.copyWith(
        fontSize: 56.0, fontWeight: FontWeight.w400),
    display2: _baseTextStyleMerriweather.copyWith(
        fontSize: 45.0, fontWeight: FontWeight.w400),
    display1: _baseTextStyleMerriweather.copyWith(
        fontSize: 34.0, fontWeight: FontWeight.w400),
    headline: _baseTextStyleMerriweather.copyWith(
        fontSize: 24.0, fontWeight: FontWeight.w400),
    title: _baseTextStyleMerriweather.copyWith(
        fontSize: 20.0, fontWeight: FontWeight.w500),
    subhead: _baseTextStyleMerriweather.copyWith(
        fontSize: 16.0, fontWeight: FontWeight.w400),
    body2: _baseTextStyleMerriweather.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    body1: _baseTextStyleMerriweather.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w400),
    caption: _baseTextStyleMerriweather.copyWith(
        fontSize: 12.0, fontWeight: FontWeight.w400),
    button: _baseTextStyleMerriweather.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    subtitle: _baseTextStyleMerriweather.copyWith(
        fontSize: 14.0, fontWeight: FontWeight.w500),
    overline: _baseTextStyleMerriweather.copyWith(
        fontSize: 10.0, fontWeight: FontWeight.w400),
  );

  // Themes
  static const themeAccent = Colors.indigo;

  static double textInt;

  // Placeholders
  static const placeholderTitle = 'Titulo';
  static const placeholderText = 'Texto';
  static const placeholderDate = '01/01/1970';
  static const placeholderImg = 'https://i.imgur.com/95fvCBU.jpg';
  static const placeholderTagMetadata = {
    'title': 'Textos do ',
    'authorName': 'Kalil',
    'collection': 'stories',
    'type': 'texts',
    'tags': [],
  };

  // Animation durations
  static const durationAnimationShort = Duration(milliseconds: 200);
  static const durationAnimationMedium = Duration(milliseconds: 400);
  static const durationAnimationLong = Duration(milliseconds: 600);
  static const durationAnimationRoute = Duration(milliseconds: 700);
}
