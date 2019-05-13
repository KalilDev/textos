import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/src/textContent.dart';
import 'package:textos/ui/cardView/favoriteFAB.dart';
import 'package:textos/ui/drawer/drawer.dart';
import 'package:textos/ui/widgets.dart';

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
    exit(List data) async {
      // Nasty
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
      child: Consumer<DarkModeProvider>(
        builder: (context, provider, _) {
          ThemeData overrideTheme;

          if (provider.isDarkMode) {
            overrideTheme = Constants.themeDataDark;
          } else {
            overrideTheme = Constants.themeDataLight;
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: Constants.themeDataDark,
            theme: overrideTheme,
            home: Scaffold(
              body: TextCard(textContent: textContent, exit: exit),
              drawer: TextAppDrawer(),
            ),
          );
        },
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  final TextContent textContent;
  final Function exit;

  TextCard({@required this.textContent, @required this.exit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
            tag: 'image' + textContent.textPath,
            child: ImageBackground(
                img: textContent.imgUrl,
                enabled: false,
                key: Key('image' + textContent.textPath))),
        DraggableScrollableSheet(
            initialChildSize: 1.0,
            maxChildSize: 1.0,
            minChildSize: 0.8,
            builder: (context, controller) =>
                _TextWidget(
                  controller: controller,
                  exit: exit,
                  textContent: textContent,
                )),
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

class _TextWidget extends StatefulWidget {
  final ScrollController controller;
  final Function exit;
  final TextContent textContent;

  _TextWidget({@required this.controller,
    @required this.exit,
    @required this.textContent});

  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  bool hasMoved;

  void pop(BuildContext context) {
    widget.exit([
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

  @override
  void initState() {
    hasMoved = false;
    widget.controller.addListener(() {
      setState(() => hasMoved = true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.hasClients &&
        widget.controller.position.userScrollDirection ==
            ScrollDirection.idle &&
        widget.controller.offset <=
            widget.controller.position.minScrollExtent &&
        hasMoved) pop(context);
    final textTheme = Theme
        .of(context)
        .textTheme;

    return GestureDetector(
      onTap: () => pop(context),
      child: SafeArea(
        child: Hero(
          tag: 'body' + widget.textContent.textPath,
          child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: BlurOverlay(
                  enabled: Provider
                      .of<BlurProvider>(context)
                      .textsBlur,
                  radius: 20,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SingleChildScrollView(
                            controller: widget.controller,
                            child: Column(children: <Widget>[
                              Text(widget.textContent.title,
                                  textAlign: TextAlign.center,
                                  style: textTheme.display1),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.textContent.text,
                                  style: textTheme.body1.copyWith(
                                      fontSize:
                                      Provider
                                          .of<TextSizeProvider>(context)
                                          .textSize *
                                          4.5)),
                              SizedBox(
                                height: 55,
                                child: Center(
                                  child: Text(widget.textContent.date,
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
      ),
    );
  }
}
