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
  static const textPickAccent = 'Alterar cor do tema';
  static const textBack = 'Voltar';
  static const textsMisc = 'Miscelânea';
  static final Map<String, dynamic> textNoTextAvailable = {
    'title': 'Não há nenhum texto nessa categoria',
    'img': 'https://i.imgur.com/yugoBNL.jpg',
    'text':
    'Nenhum texto foi encontrado nessa categoria, tente o seguinte: Desconecte e reconecte seu telefone à internet',
    'favoriteCount': 0,
    'date': DateTime
        .now()
        .day
        .toString() +
        '/' +
        DateTime
            .now()
            .month
            .toString() +
        '/' +
        DateTime
            .now()
            .year
            .toString(),
    'path': 'NULL/TEXTNOTFOUNDID'
  };

  // Theme Light
  static const themeAccentLight = Colors.indigo;
  static const themeBackgroundLight = Colors.white;
  static const themeForegroundLight = Colors.black;
  static final themeDataLight = ThemeData(
      brightness: Brightness.light,
      accentColor: themeAccentLight,
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
  static final themeAccentDark = Colors.indigo.shade700;
  static const themeBackgroundDark = Colors.black;
  static const themeForegroundDark = Colors.white;
  static final themeDataDark = ThemeData(
      brightness: Brightness.dark,
      accentColor: themeAccentDark,
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
  static const durationAnimationRoute = Duration(milliseconds: 600);

  // About
  static const aboutMe = 'Sou um jovem escritor nascido em 2003, aluno do Colégio Santo Antônio desde 2016, que começou a escrever no final de 2018. Nunca gostei muito da arte da escrita, tampouco dominei-a, mas algo mudou ano passado. Com o projeto dos professores de redação, de criar um jornal para cada metade da turma, comecei a tomar gosto e a praticar a escrita, e posteriormente, com muito incentivo de um amigo, decidi publicar textos. Comecei a faze-lo por uma pagina no Instagram chamada @TextosDoKalil que eu criei no dia 28. Desde lá eu pensava sobre o quão retardado e ineficiente é isso, uma pagina para postar TEXTOS numa rede social projetada para FOTOS. Rapidamente as limitações se mostraram, e eram muitas: Um mecanismo ineficiente para compartilhar um texto rapidamente, não haver como colocar um título, formatar o texto, alterar a fonte, e não haver um modo escuro para cansar menos a vista, mas continuei usando. Continuei usando pois todos os meu amigos criadores de conteúdo autoral o utilizam: Músicos que postam suas composições junto com fotos, desenhistas que publicam maravilhosos desenhos, e escritores que expõem poemas ao lado de imagens de festas.';
  static const aboutApp = 'Decidi então criar meu aplicativo, não só para aperfeiçoar a experiencia de consumidores de conteúdo original e de seus criadores, mas também porque já queria aprender a fazer aplicativos, e então iniciou a minha jornada em fevereiro: Baixei os programas necessários, tentei criar um aplicativo usando as ferramentas padrão e após algumas semanas, aprendi como usa-las efetivamente, mas não gostei da experiencia de uso. Para fazer qualquer alteração, era necessário muito esforço, e para visualiza-las, demorava mais um minuto até que elas apareçam no telefone. Percebi então que ou eu encontrava outra maneira, ou eu demoraria no mínimo um ano para fazer meu app dos sonhos.';
  static const aboutFlutter = 'Me deparei então com o Flutter: Um novo kit de ferramentas para desenvolvimento de apps criado pela a Google. As mudanças são instantâneas, as funcionalidades são bem documentadas, a comunidade é bem ativa, há suporte para todas as funcionalidades essenciais, e no geral, é tudo mais conciso e eficiente. Há também outra grande vantagem: Os aplicativos criados com ele rodam em iPhones, aparelhos com Android, computadores e na web. Criei alguns aplicativos por mais umas semanas para aprender a utilizar o Flutter, e em março, em uma tarde eu tinha meu primeiro protótipo do app, que então acrescentei recursos, e embelezei a interface, até chegar no produto final que você está usando.';
  static const aboutGreeting = 'Espero que você goste desse app criado com muito ❤, de um criador para outros.';
}
