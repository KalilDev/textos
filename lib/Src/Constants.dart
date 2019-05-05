import 'package:flutter/material.dart';

class Constants {
  // Text
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
  static const textTextBlurDrawer = 'Borrar a gaveta';
  static const textTextBlurButtons = 'Borrar os botões';
  static const textTextBlurText = 'Borrar fundo dos textos';
  static const textTooltipTextSizeLess = 'Diminuir tamanho do texto';
  static const textTooltipTextSizePlus = 'Aumentar tamanho do texto';
  static const textTooltipFav = 'Adicionar aos favoritos';
  static const textTooltipDrawer = 'Abrir gaveta';
  static final Map<String, dynamic> textNoTextAvailable = {
    'title': 'Não há nenhum texto nessa categoria',
    'img': 'https://i.imgur.com/yugoBNL.jpg',
    'text': 'Nenhum texto foi encontrado nessa categoria, tente o seguinte: Espere o autor publicar algum texto nessa categoria, desconecte e reconecte a internet, ou entre em contato com o criador do aplicativo caso tenha certeza que deveria ter um texto aqui',
    'favorites': 0,
    'date': DateTime.now().toIso8601String().replaceAll('-', '/').substring(
        0, 10),
    'tags': textTag,
    'id': 'TEXTNOTFOUNDID'
  };

  // Authors
  static const List<String> authorNames = [
    'do Kalil',
    'da Maria'
  ];
  static const List<String> authorCollections = [
    'stories',
    'maria'
  ];

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
      backgroundColor: themeBackgroundLight);

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
      backgroundColor: themeBackgroundDark);

  // Themes
  static const themeAccent = Colors.indigo;

  static double textInt;

  TextStyle textstyleTitle(double size) =>
      TextStyle(
          fontSize: size * 8,
          fontWeight: FontWeight.bold,
          fontFamily: 'Merriweather');

  TextStyle textstyleFilter(double size, bool isDark) =>
      TextStyle(
          fontSize: size * 3,
          color: isDark
              ? themeForegroundDark.withAlpha(150)
              : themeForegroundLight.withAlpha(150),
          fontFamily: 'Merriweather');

  TextStyle textstyleText(double size) =>
      TextStyle(
          fontSize: size * 4.5,
          fontFamily: 'Muli');

  TextStyle textstyleDate(double size) =>
      TextStyle(
        fontSize: size * 5,
        fontFamily: 'Merriweather',
      );

  TextStyle textStyleButton(double size) =>
      TextStyle(
          fontSize: size * 3,
          fontFamily: 'Merriweather');

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
          iconTheme: IconThemeData(
            color: isDark ? themeForegroundDark : themeForegroundLight,
          )
      );
}
