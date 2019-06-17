import 'package:flutter/material.dart';

/// Main Views
const String textFilter = 'FILTRO';
const String textAllTag = 'Todos';
const String textNoFavs = 'Não há nenhum texto nos favoritos';
const String textNoTexts = 'Não há nenhum texto nesta categoria';

/// Login Screen
const String textAppName = 'Textos do Kalil';
const String textLogin = 'Login';
const String textEmail = 'Endereço de Email';
const String textPassword = 'Senha';
const String textName = 'Nome';
const String textSurname = 'Sobrenome';
const String textNewUser = 'Criar Usuario';
const String textLoginAnonymously = 'Entrar anonimamente';
const String textAnonyConsequences = 'Você realmente quer entrar anonimamente? Se faze-lo, não poderá postar nada, incluindo comentarios';
const String textLoginWithGoogle = 'Fazer login com o Google';
const String textError = 'Erro';
const String textOk = 'Ooops';
const String textConfirm = 'Confirmar';
const String textYes = 'Sim';
const String textNo = 'Não';

/// Tabs
const String textAuthors = 'Autores';
const String textTexts = 'Textos';
const String textFavs = 'Favoritos';
const String textSettings = 'Configurações';

/// Settings
const String textTextSize = 'Tamanho do texto';
const String textDarkTheme = 'Tema Escuro';
const String textRestore = 'Restaurar o Padrão';
const String textBlurButtons = 'Borrar os botões';
const String textBlurText = 'Borrar fundo dos textos';
const String textText = 'Texto';
const String textCleanFavs = 'Limpar Favoritos';
const String textBlur = 'Borrado';
const String textMisc = 'Miscelânea';
const String textTema = 'Tema';
const String textTextAlignment = 'Alinhamento do texto';
const String textLogout = 'Sair';

/// Tooltips
const String textTooltipTabPageToggle = 'Alterar entre lista e paginas';
const String textTooltipBackdropToggle = 'Abrir/fechar as configurações';
const String textTooltipAlignLeft = 'Alinhar à Esquerda';
const String textTooltipAlignCenter = 'Centralizar';
const String textTooltipAlignRight = 'Alinhar à Direita';
const String textTooltipAlignJustify = 'Justificar';

// Theme Light
const Color _themeBackgroundLight = Colors.white;
const Color _themeForegroundLight = Colors.black;
const ColorScheme _colorSchemeLight = ColorScheme(
    primary: Color(0xFF3F51B5),
    primaryVariant: Color(0xFF002984),
    secondary: Color(0xff3f8cb5),
    secondaryVariant: Color(0xFF005f85),
    surface: _themeBackgroundLight,
    background: _themeBackgroundLight,
    error: Color(0xFFB00020),
    onPrimary: _themeBackgroundLight,
    onSecondary: _themeForegroundLight,
    onSurface: _themeForegroundLight,
    onBackground: _themeForegroundLight,
    onError: _themeBackgroundLight,
    brightness: Brightness.light);

final ThemeData themeDataLight = themeFromScheme(_colorSchemeLight);

// Theme Dark
const Color _themeBackgroundDark = Color(0xFF0C0D11);
const Color _themeForegroundDark = Colors.white;
const ColorScheme _colorSchemeDark = ColorScheme(
    primary: Color(0xFF9fa8da),
    primaryVariant: Color(0xFF6f79a8),
    secondary: Color(0xff9fc5da),
    secondaryVariant: Color(0xFF6f94a8),
    surface: _themeBackgroundDark,
    background: _themeBackgroundDark,
    error: Color(0xFFCF6679),
    onPrimary: _themeBackgroundDark,
    onSecondary: _themeBackgroundDark,
    onSurface: _themeForegroundDark,
    onBackground: _themeForegroundDark,
    onError: _themeBackgroundDark,
    brightness: Brightness.dark);

final ThemeData themeDataDark = themeFromScheme(_colorSchemeDark);

// BaseTextStyles
final TextStyle _baseTextStyleSecondary =
TextStyle(fontFamily: 'Merriweather');
final TextStyle _baseTextStylePrimary = TextStyle(fontFamily: 'Muli');

// TextTheme
final TextTheme textThemePrimary = TextTheme(
  display4:
      _baseTextStylePrimary.copyWith(fontSize: 112.0, fontWeight: FontWeight.w100),
  display3:
      _baseTextStylePrimary.copyWith(fontSize: 56.0, fontWeight: FontWeight.w400),
  display2:
      _baseTextStylePrimary.copyWith(fontSize: 45.0, fontWeight: FontWeight.w400),
  display1:
      _baseTextStylePrimary.copyWith(fontSize: 34.0, fontWeight: FontWeight.w400),
  headline:
      _baseTextStylePrimary.copyWith(fontSize: 24.0, fontWeight: FontWeight.w400),
  title:
      _baseTextStylePrimary.copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
  subhead:
      _baseTextStylePrimary.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
  body2:
      _baseTextStylePrimary.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  body1:
      _baseTextStylePrimary.copyWith(fontSize: 14.0, fontWeight: FontWeight.w400),
  caption:
      _baseTextStylePrimary.copyWith(fontSize: 12.0, fontWeight: FontWeight.w400),
  button:
      _baseTextStylePrimary.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  subtitle:
      _baseTextStylePrimary.copyWith(fontSize: 14.0, fontWeight: FontWeight.w500),
  overline:
      _baseTextStylePrimary.copyWith(fontSize: 10.0, fontWeight: FontWeight.w400),
);
final TextTheme textThemeSecondary = TextTheme(
  display4: _baseTextStyleSecondary.copyWith(
      fontSize: 112.0, fontWeight: FontWeight.w100),
  display3: _baseTextStyleSecondary.copyWith(
      fontSize: 56.0, fontWeight: FontWeight.w400),
  display2: _baseTextStyleSecondary.copyWith(
      fontSize: 45.0, fontWeight: FontWeight.w400),
  display1: _baseTextStyleSecondary.copyWith(
      fontSize: 34.0, fontWeight: FontWeight.w400),
  headline: _baseTextStyleSecondary.copyWith(
      fontSize: 24.0, fontWeight: FontWeight.w400),
  title: _baseTextStyleSecondary.copyWith(
      fontSize: 20.0, fontWeight: FontWeight.w500),
  subhead: _baseTextStyleSecondary.copyWith(
      fontSize: 16.0, fontWeight: FontWeight.w400),
  body2: _baseTextStyleSecondary.copyWith(
      fontSize: 14.0, fontWeight: FontWeight.w500),
  body1: _baseTextStyleSecondary.copyWith(
      fontSize: 14.0, fontWeight: FontWeight.w400),
  caption: _baseTextStyleSecondary.copyWith(
      fontSize: 12.0, fontWeight: FontWeight.w400),
  button: _baseTextStyleSecondary.copyWith(
      fontSize: 14.0, fontWeight: FontWeight.w500),
  subtitle: _baseTextStyleSecondary.copyWith(
      fontSize: 14.0, fontWeight: FontWeight.w500),
  overline: _baseTextStyleSecondary.copyWith(
      fontSize: 10.0, fontWeight: FontWeight.w400),
);

// Placeholders
const String placeholderTitle = 'Titulo';
const String placeholderText = 'Texto';
const String placeholderDate = '01/01/1970';
const String placeholderImg = 'https://i.imgur.com/95fvCBU.jpg';

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
Brightness inverseBrightness(Brightness b) => b == Brightness.dark ? Brightness.light : Brightness.dark;
ThemeData themeFromScheme(ColorScheme scheme) => ThemeData(
    colorScheme: scheme,
    brightness: scheme.brightness,
    scaffoldBackgroundColor: scheme.background,
    accentColor: scheme.secondary,
    accentColorBrightness: scheme.onSecondary != scheme.background ? scheme.brightness : inverseBrightness(scheme.brightness),
    canvasColor: scheme.background,
    dividerColor: scheme.onBackground.withAlpha(70),
    primaryColor: scheme.primary,
    primaryColorBrightness: scheme.onPrimary != scheme.background ? scheme.brightness : inverseBrightness(scheme.brightness),
    backgroundColor: scheme.background,
    textTheme: textThemePrimary.apply(
        bodyColor: getTextColor(0.87,
            bg: scheme.background, main: scheme.onBackground),
        displayColor: getTextColor(0.87,
            bg: scheme.background,
            main: scheme.onBackground)),
    primaryTextTheme: textThemePrimary.apply(
        bodyColor: getTextColor(0.87,
            bg: scheme.background, main: scheme.onBackground),
        displayColor: getTextColor(0.87,
            bg: scheme.background,
            main: scheme.onBackground)),
    accentTextTheme: textThemeSecondary.apply(
        bodyColor: getTextColor(0.87,
            bg: scheme.background, main: scheme.onBackground),
        displayColor: getTextColor(0.87,
            bg: scheme.background,
            main: scheme.onBackground)));