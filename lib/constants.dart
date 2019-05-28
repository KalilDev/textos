import 'package:flutter/material.dart';

  // Text
const String textTextos = 'Textos ';
const String textFilter = 'FILTRO';
const String textAllTag = 'Todos';
const String textTema = 'Tema';
const String textConfigs = 'Configurações';
const String textFavs = 'Favoritos';
const String textTextSize = 'Tamanho do texto';
const String textTextTheme = 'Tema Escuro';
const String textTextTrash = 'Restaurar o Padrão';
const String textTextBlurDrawer = 'Borrar a gaveta';
const String textTextBlurButtons = 'Borrar os botões';
const String textTextBlurText = 'Borrar fundo dos textos';
const String textTooltipTextSizeLess = 'Diminuir tamanho do texto';
const String textTooltipTextSizePlus = 'Aumentar tamanho do texto';
const String textTooltipFav = 'Adicionar aos favoritos';
const String textText = 'Texto';
const String textCleanFavs = 'Limpar Favoritos';
const String textBlur = 'Borrado';
const String textPickAccent = 'Alterar cor do tema';
const String textsMisc = 'Miscelânea';
final Map<String, dynamic> textNoTextAvailable = <String, dynamic>{
    'title': 'Não há nenhum texto nessa categoria',
    'img': 'https://i.imgur.com/yugoBNL.jpg',
    'text':
    'Nenhum texto foi encontrado nessa categoria, tente o seguinte: Desconecte e reconecte seu telefone à internet',
    'favoriteCount': 0,
    'path': 'NULL/TEXTNOTFOUNDID'
  };

  // Theme Light
final Color themePrimaryLight = Colors.indigo.shade500;
const Color themeAccentLight = Color(0xff3f8cb5);
const Color themeBackgroundLight = Colors.white;
const Color themeForegroundLight = Colors.black;
final ThemeData themeDataLight = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: themeBackgroundLight,
      accentColorBrightness: Brightness.dark,
      accentColor: themeAccentLight,
      canvasColor: themeBackgroundLight,
      dividerColor: themeForegroundLight.withAlpha(70),
      primaryColorBrightness: Brightness.dark,
      primaryColor: themePrimaryLight,
      backgroundColor: themeBackgroundLight,
      textTheme: textThemeMuli.apply(
          bodyColor: themeForegroundLight,
          displayColor: Color.alphaBlend(
              themeForegroundLight.withAlpha(221), themeBackgroundLight)),
      accentTextTheme: textThemeMerriweather.apply(
          bodyColor: themeForegroundLight,
          displayColor: Color.alphaBlend(
              themeForegroundLight.withAlpha(221), themeBackgroundLight)));

  // Theme Dark
final Color themePrimaryDark = Colors.indigo.shade200;
const Color themeAccentDark = Color(0xff9fc5da);
const Color themeBackgroundDark = Colors.black;
const Color themeForegroundDark = Colors.white;
final ThemeData themeDataDark = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: themeBackgroundDark,
      accentColor: themeAccentDark,
      accentColorBrightness: Brightness.light,
      canvasColor: themeBackgroundDark,
      dividerColor: themeForegroundDark.withAlpha(70),
      primaryColorBrightness: Brightness.light,
      backgroundColor: themeBackgroundDark,
      textTheme: textThemeMuli.apply(
          bodyColor: Color.alphaBlend(
              themeForegroundDark.withAlpha(221), themeBackgroundDark),
          displayColor: Color.alphaBlend(
              themeForegroundDark.withAlpha(221), themeBackgroundDark)),
      accentTextTheme: textThemeMerriweather.apply(
          bodyColor: Color.alphaBlend(
              themeForegroundDark.withAlpha(221), themeBackgroundDark),
          displayColor: Color.alphaBlend(
              themeForegroundDark.withAlpha(221), themeBackgroundDark)));

  // BaseTextStyles
final TextStyle _baseTextStyleMuli = TextStyle(fontFamily: 'Muli');
final TextStyle _baseTextStyleMerriweather =
  TextStyle(fontFamily: 'Merriweather');

  // TextTheme
final TextTheme textThemeMuli = TextTheme(
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
const String aboutMe = 'Sou um jovem escritor nascido em 2003, aluno do Colégio Santo Antônio desde 2016, que começou a escrever no final de 2018. Nunca gostei muito da arte da escrita, tampouco dominei-a, mas algo mudou ano passado. Com o projeto dos professores de redação, de criar um jornal para cada metade da turma, comecei a tomar gosto e a praticar a escrita, e posteriormente, com muito incentivo de um amigo, decidi publicar textos. Comecei a faze-lo por uma pagina no Instagram chamada @TextosDoKalil que eu criei no dia 28. Desde lá eu pensava sobre o quão retardado e ineficiente é isso, uma pagina para postar TEXTOS numa rede social projetada para FOTOS. Rapidamente as limitações se mostraram, e eram muitas: Um mecanismo ineficiente para compartilhar um texto rapidamente, não haver como colocar um título, formatar o texto, alterar a fonte, e não haver um modo escuro para cansar menos a vista, mas continuei usando. Continuei usando pois todos os meu amigos criadores de conteúdo autoral o utilizam: Músicos que postam suas composições junto com fotos, desenhistas que publicam maravilhosos desenhos, e escritores que expõem poemas ao lado de imagens de festas.';
const String aboutApp = 'Decidi então criar meu aplicativo, não só para aperfeiçoar a experiencia de consumidores de conteúdo original e de seus criadores, mas também porque já queria aprender a fazer aplicativos, e então iniciou a minha jornada em fevereiro: Baixei os programas necessários, tentei criar um aplicativo usando as ferramentas padrão e após algumas semanas, aprendi como usa-las efetivamente, mas não gostei da experiencia de uso. Para fazer qualquer alteração, era necessário muito esforço, e para visualiza-las, demorava mais um minuto até que elas apareçam no telefone. Percebi então que ou eu encontrava outra maneira, ou eu demoraria no mínimo um ano para fazer meu app dos sonhos.';
const String aboutFlutter = 'Me deparei então com o Flutter: Um novo kit de ferramentas para desenvolvimento de apps criado pela a Google. As mudanças são instantâneas, as funcionalidades são bem documentadas, a comunidade é bem ativa, há suporte para todas as funcionalidades essenciais, e no geral, é tudo mais conciso e eficiente. Há também outra grande vantagem: Os aplicativos criados com ele rodam em iPhones, aparelhos com Android, computadores e na web. Criei alguns aplicativos por mais umas semanas para aprender a utilizar o Flutter, e em março, em uma tarde eu tinha meu primeiro protótipo do app, que então acrescentei recursos, e embelezei a interface, até chegar no produto final que você está usando.';
const String aboutGreeting = 'Espero que você goste desse app criado com muito ❤, de um criador para outros.';