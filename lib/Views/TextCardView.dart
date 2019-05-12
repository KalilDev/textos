import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:textos/Src/TextContent.dart';
import 'package:textos/Widgets/Widgets.dart';

class TextCardView extends StatelessWidget {
  const TextCardView({Key key,
    @required this.textContent,
    @required this.darkModeProvider,
    @required this.textSizeProvider,
    @required this.blurProvider,
    @required this.favoritesProvider})
      : super(key: key);

  final TextContent textContent;
  final DarkModeProvider darkModeProvider;
  final BlurProvider blurProvider;
  final TextSizeProvider textSizeProvider;
  final FavoritesProvider favoritesProvider;

  @override
  Widget build(BuildContext context) {
    ThemeData overrideTheme;
    if (darkModeProvider.isDarkMode) {
      overrideTheme = Constants.themeDataDark;
    } else {
      overrideTheme = Constants.themeDataLight;
    }
    exit() {
      Navigator.pop(context);
    }

    return ChangeNotifierProvider<FavoritesProvider>(
      builder: (_) => favoritesProvider.copy(),
      child: ChangeNotifierProvider<DarkModeProvider>(
          builder: (_) => darkModeProvider.copy(),
          child: ChangeNotifierProvider<BlurProvider>(
              builder: (_) => blurProvider.copy(),
              child: ChangeNotifierProvider<TextSizeProvider>(
                  builder: (_) => textSizeProvider.copy(),
                  child: MaterialApp(
                      darkTheme: Constants.themeDataDark,
                      theme: overrideTheme,
                      debugShowCheckedModeBanner: false,
                      home: new Scaffold(
                          drawer: TextAppDrawer(),
                          body: TextCard(
                              textContent: textContent, exit: exit)))))),
    );
  }
}

class TextCard extends StatelessWidget {
  final TextContent textContent;
  final Function exit;

  TextCard({@required this.textContent, @required this.exit});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => exit(),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Hero(
                    tag: 'image' + textContent.textPath,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: ImageBackground(
                          img: textContent.imgUrl,
                          enabled: false,
                          key: Key('image' + textContent.textPath)),
                    )),
                Hero(
                  tag: 'body' + textContent.textPath,
                  child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: BlurOverlay(
                          enabled:
                          Provider
                              .of<BlurProvider>(context)
                              .textsBlur,
                          radius: 20,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: SingleChildScrollView(
                                    child: Column(children: <Widget>[
                                      Text(textContent.title,
                                          textAlign: TextAlign.center,
                                          style: textTheme.display1),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(textContent.text,
                                          style: textTheme.body1.copyWith(
                                              fontSize:
                                              Provider
                                                  .of<TextSizeProvider>(
                                                  context)
                                                  .textSize *
                                                  4.5)),
                                      SizedBox(
                                        height: 55,
                                        child: Center(
                                          child: Text(textContent.date,
                                              style: textTheme.title),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Positioned(
                  child: FavoriteFAB(
                      title: textContent.title, path: textContent.textPath),
                  right: 10,
                  bottom: 10,
                ),
                Positioned(
                  child: TextSizeButton(),
                  left: 10,
                  bottom: 13.5,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: MenuButton(),
          top: MediaQuery
              .of(context)
              .padding
              .top - 2.5,
          left: -2.5,
        ),
      ],
    );
  }
}
