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
    exit(List data) async {
      await Future.delayed(Duration(milliseconds: 1));
      if (Navigator.of(context).canPop()) Navigator.pop(context, data);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesProvider>(
            builder: (_) => favoritesProvider.copy()),
        ChangeNotifierProvider<DarkModeProvider>(
            builder: (_) => darkModeProvider.copy()),
        ChangeNotifierProvider<BlurProvider>(
            builder: (_) => blurProvider.copy()),
        ChangeNotifierProvider<TextSizeProvider>(
            builder: (_) => textSizeProvider.copy()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: Constants.themeDataDark,
        theme: overrideTheme,
        home: Scaffold(
            drawer: TextAppDrawer(),
            body: TextCard(textContent: textContent, exit: exit)),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  final TextContent textContent;
  final Function exit;
  final double minSize;

  TextCard(
      {@required this.textContent, @required this.exit, this.minSize = 0.8});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    void pop(BuildContext context) {
      exit([
        Provider
            .of<FavoritesProvider>(context)
            .favoritesList,
        Provider
            .of<DarkModeProvider>(context)
            .isDarkMode,
        Provider
            .of<BlurProvider>(context)
            .blurSettings,
        Provider
            .of<TextSizeProvider>(context)
            .textSize
      ]);
    }

    return Stack(
      children: <Widget>[
        Hero(
            tag: 'image' + textContent.textPath,
            child: ImageBackground(
                img: textContent.imgUrl,
                enabled: false,
                key: Key('image' + textContent.textPath))),
        LayoutBuilder(
          builder: (context, mainConstraints) =>
              DraggableScrollableSheet(
                  initialChildSize: 1.0,
                  maxChildSize: 1.0,
                  minChildSize: minSize,
                  builder: (context, controller) =>
                      LayoutBuilder(builder: (context, constraints) {
                        if ((constraints.maxHeight /
                            mainConstraints.maxHeight) ==
                            minSize) pop(context);

                        return GestureDetector(
                          onTap: () => pop(context),
                          child: SafeArea(
                            child: Hero(
                              tag: 'body' + textContent.textPath,
                              child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            20)),
                                    child: BlurOverlay(
                                      enabled: Provider
                                          .of<BlurProvider>(context)
                                          .textsBlur,
                                      radius: 20,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              child: SingleChildScrollView(
                                                controller: controller,
                                                child: Column(
                                                    children: <Widget>[
                                                      Text(textContent.title,
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: textTheme
                                                              .display1),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(textContent.text,
                                                          style: textTheme.body1
                                                              .copyWith(
                                                              fontSize:
                                                              Provider
                                                                  .of<
                                                                  TextSizeProvider>(
                                                                  context)
                                                                  .textSize *
                                                              4.5)),
                                                      SizedBox(
                                                        height: 55,
                                                        child: Center(
                                                          child: Text(
                                                              textContent.date,
                                                              style: textTheme
                                                                  .title),
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
                          ),
                        );
                      })),
        ),
        Positioned(
          child:
          FavoriteFAB(title: textContent.title, path: textContent.textPath),
          right: 10,
          bottom: 10,
        ),
        Positioned(
          child: TextSizeButton(),
          left: 10,
          bottom: 13.5,
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
