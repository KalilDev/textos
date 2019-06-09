import 'package:flutter/material.dart';

// Text
const String textFilter = 'FILTRO';
const String textAllTag = 'Todos';
const String textTema = 'Tema';
const String textConfigs = 'Configurações';
const String textFavs = 'Favoritos';
const String textTextSize = 'Tamanho do texto';
const String textTextTheme = 'Tema Escuro';
const String textTextTrash = 'Restaurar o Padrão';
const String textTextBlurButtons = 'Borrar os botões';
const String textTextBlurText = 'Borrar fundo dos textos';
const String textText = 'Texto';
const String textCleanFavs = 'Limpar Favoritos';
const String textBlur = 'Borrado';
const String textMisc = 'Miscelânea';
const String textAuthors = 'Autores';
const String textTexts = 'Textos';
const String textNoFavs = 'Não há nenhum texto nos favoritos';
const String textNoTexts = 'Não há nenhum texto nesta categoria';

// Theme Light
const Color themeBackgroundLight = Colors.white;
const Color themeForegroundLight = Colors.black;
const ColorScheme colorSchemeLight = ColorScheme(
    primary: Color(0xFF3F51B5),
    primaryVariant: Color(0xFF002984),
    secondary: Color(0xff3f8cb5),
    secondaryVariant: Color(0xFF005f85),
    surface: themeBackgroundLight,
    background: themeBackgroundLight,
    error: Color(0xFFB00020),
    onPrimary: themeBackgroundLight,
    onSecondary: themeForegroundLight,
    onSurface: themeForegroundLight,
    onBackground: themeForegroundLight,
    onError: themeBackgroundLight,
    brightness: Brightness.light);

final ThemeData themeDataLight = ThemeData(
    colorScheme: colorSchemeLight,
    brightness: Brightness.light,
    scaffoldBackgroundColor: colorSchemeLight.background,
    accentColorBrightness: Brightness.dark,
    accentColor: colorSchemeLight.secondary,
    canvasColor: colorSchemeLight.background,
    dividerColor: colorSchemeLight.onBackground.withAlpha(70),
    primaryColorBrightness: Brightness.dark,
    primaryColor: colorSchemeLight.primary,
    backgroundColor: themeBackgroundLight,
    textTheme: textThemeMuli.apply(
        bodyColor: getTextColor(0.87,
            bg: colorSchemeLight.background,
            main: colorSchemeLight.onBackground),
        displayColor: getTextColor(0.87,
            bg: colorSchemeLight.background,
            main: colorSchemeLight.onBackground)),
    primaryTextTheme: textThemeMuli.apply(
        bodyColor: getTextColor(0.87,
            bg: colorSchemeLight.background,
            main: colorSchemeLight.onBackground),
        displayColor: getTextColor(0.87,
            bg: colorSchemeLight.background,
            main: colorSchemeLight.onBackground)),
    accentTextTheme: textThemeMerriweather.apply(
        bodyColor: getTextColor(0.87,
            bg: colorSchemeLight.background,
            main: colorSchemeLight.onBackground),
        displayColor: getTextColor(0.87,
            bg: colorSchemeLight.background,
            main: colorSchemeLight.onBackground)));

// Theme Dark
//const Color themeBackgroundDark = Color(0xFF121212);
//const Color themeBackgroundDark = Color(4280098081);
const Color themeBackgroundDark = Color(4278979857);
//const Color themeBackgroundDark = Colors.black;
const Color themeForegroundDark = Colors.white;
const ColorScheme colorSchemeDark = ColorScheme(
    primary: Color(0xFF9fa8da),
    primaryVariant: Color(0xFF6f79a8),
    secondary: Color(0xff9fc5da),
    secondaryVariant: Color(0xFF6f94a8),
    surface: themeBackgroundDark,
    background: themeBackgroundDark,
    error: Color(0xFFCF6679),
    onPrimary: themeBackgroundDark,
    onSecondary: themeBackgroundDark,
    onSurface: themeForegroundDark,
    onBackground: themeForegroundDark,
    onError: themeBackgroundDark,
    brightness: Brightness.dark);

final ThemeData themeDataDark = ThemeData(
    colorScheme: colorSchemeDark,
    brightness: colorSchemeDark.brightness,
    scaffoldBackgroundColor: colorSchemeDark.background,
    accentColor: colorSchemeDark.secondary,
    accentColorBrightness: Brightness.light,
    canvasColor: colorSchemeDark.background,
    dividerColor: colorSchemeDark.onBackground.withAlpha(70),
    primaryColor: colorSchemeDark.primary,
    primaryColorBrightness: Brightness.light,
    backgroundColor: colorSchemeDark.background,
    textTheme: textThemeMuli.apply(
        bodyColor: getTextColor(0.87,
            bg: colorSchemeDark.background, main: colorSchemeDark.onBackground),
        displayColor: getTextColor(0.87,
            bg: colorSchemeDark.background,
            main: colorSchemeDark.onBackground)),
    primaryTextTheme: textThemeMuli.apply(
        bodyColor: getTextColor(0.87,
            bg: colorSchemeDark.background, main: colorSchemeDark.onBackground),
        displayColor: getTextColor(0.87,
            bg: colorSchemeDark.background,
            main: colorSchemeDark.onBackground)),
    accentTextTheme: textThemeMerriweather.apply(
        bodyColor: getTextColor(0.87,
            bg: colorSchemeDark.background, main: colorSchemeDark.onBackground),
        displayColor: getTextColor(0.87,
            bg: colorSchemeDark.background,
            main: colorSchemeDark.onBackground)));

// BaseTextStyles
final TextStyle _baseTextStyleMuli = TextStyle(fontFamily: 'Muli');
final TextStyle _baseTextStyleMerriweather =
    TextStyle(fontFamily: 'Merriweather');

// TextTheme
final TextTheme textThemeMuli = TextTheme(
  display4:
      _baseTextStyleMuli.copyWith(fontSize: 112.0, fontWeight: FontWeight.w100),
  display3:
      _baseTextStyleMuli.copyWith(fontSize: 56.0, fontWeight: FontWeight.w400),
  display2:
      _baseTextStyleMuli.copyWith(fontSize: 45.0, fontWeight: FontWeight.w400),
  display1:
      _baseTextStyleMuli.copyWith(fontSize: 34.0, fontWeight: FontWeight.w400),
  headline:
      _baseTextStyleMuli.copyWith(fontSize: 24.0, fontWeight: FontWeight.w400),
  title:
      _baseTextStyleMuli.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
  subhead:
      _baseTextStyleMuli.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
  body2:
      _baseTextStyleMuli.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  body1:
      _baseTextStyleMuli.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400),
  caption:
      _baseTextStyleMuli.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
  button:
      _baseTextStyleMuli.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  subtitle:
      _baseTextStyleMuli.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  overline:
      _baseTextStyleMuli.copyWith(fontSize: 10.0, fontWeight: FontWeight.w400),
);
final TextTheme textThemeMerriweather = TextTheme(
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

// Placeholders
const String placeholderTitle = 'Titulo';
const String placeholderText = 'Texto';
const String placeholderDate = '01/01/1970';
const String placeholderImg = 'https://i.imgur.com/95fvCBU.jpg';
const Map<String, dynamic> placeholderTagMetadata = <String, dynamic>{
  'title': 'Textos do ',
  'authorName': 'Kalil',
  'collection': 'stories',
  'type': 'texts',
  'tags': <String>[],
};

// Animation durations
const Duration durationAnimationShort = Duration(milliseconds: 200);
const Duration durationAnimationMedium = Duration(milliseconds: 400);
const Duration durationAnimationLong = Duration(milliseconds: 600);
const Duration durationAnimationRoute = Duration(milliseconds: 600);

// About
const String aboutMe =
    'Sou um jovem escritor nascido em _2003_, aluno do _Colégio Santo Antônio_ desde _2016_, que começou a escrever no final de _2018_. Nunca gostei muito da arte da escrita, tampouco dominei-a, mas algo mudou ano passado. Com o projeto dos professores de redação, de criar um jornal para cada metade da turma, comecei a tomar gosto e a praticar a escrita, e posteriormente, com muito incentivo de um amigo, decidi publicar textos. Comecei a faze-lo por uma pagina no Instagram chamada *@TextosDoKalil* que eu criei no dia 28. Desde lá eu pensava sobre o quão retardado e ineficiente é isso, uma pagina para postar *TEXTOS* numa rede social projetada para *FOTOS*. Rapidamente as limitações se mostraram, e eram muitas: Um mecanismo ineficiente para compartilhar um texto rapidamente, não haver como colocar um título, formatar o texto, alterar a fonte, e não haver um modo escuro para cansar menos a vista, mas continuei usando. Continuei usando pois todos os meu amigos criadores de conteúdo autoral o utilizam: Músicos que postam suas composições junto com fotos, desenhistas que publicam maravilhosos desenhos, e escritores que expõem poemas ao lado de imagens de festas.';
const String aboutApp =
    'Decidi então criar meu aplicativo, não só para aperfeiçoar a experiencia de consumidores de conteúdo original e de seus criadores, mas também porque já queria aprender a fazer aplicativos, e então iniciou a minha jornada em fevereiro: Baixei os programas necessários, tentei criar um aplicativo usando as ferramentas padrão e após algumas semanas, aprendi como usa-las efetivamente, mas não gostei da experiencia de uso. Para fazer qualquer alteração, era necessário muito esforço, e para visualiza-las, demorava mais um minuto até que elas apareçam no telefone. Percebi então que ou eu encontrava outra maneira, ou eu demoraria no mínimo um ano para fazer meu app dos sonhos.';
const String aboutFlutter =
    'Me deparei então com o _Flutter_: Um novo kit de ferramentas para desenvolvimento de apps criado pela _Google_. As mudanças são instantâneas, as funcionalidades são bem documentadas, a comunidade é bem ativa, há suporte para todas as funcionalidades essenciais, e no geral, é tudo mais conciso e eficiente. Há também outra grande vantagem: Os aplicativos criados com ele rodam em _iPhones_, aparelhos com _Android_, _Computadores_ e na _Web_. Criei alguns aplicativos por mais umas semanas para aprender a utilizar o _Flutter_, e em março, em uma tarde eu tinha meu primeiro protótipo do app, que então acrescentei recursos, e embelezei a interface, até chegar no produto final que você está usando.';
const String aboutGreeting =
    '_Espero que você goste desse app feito com muito ❤, de um criador para outros._';

// MD Compliance
Color getTextColor(double percent, {Color bg, Color main}) =>
    Color.alphaBlend(main.withAlpha((255 * percent).round()), bg);
