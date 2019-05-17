import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView/favoriteFAB.dart';
import 'package:textos/ui/cardView/playbackButton.dart';
import 'package:textos/ui/drawer/drawer.dart';
import 'package:textos/ui/widgets.dart';

class CardView extends StatelessWidget {
  const CardView({Key key,
    @required this.textContent,
    @required this.darkModeProvider,
    @required this.textSizeProvider,
    @required this.blurProvider,
    @required this.favoritesProvider})
      : super(key: key);

  final Content textContent;
  final ThemeProvider darkModeProvider;
  final BlurProvider blurProvider;
  final TextSizeProvider textSizeProvider;
  final FavoritesProvider favoritesProvider;

  @override
  Widget build(BuildContext context) {
    exit(List data) async {
      HapticFeedback.selectionClick();
      // Nasty
      await Future.delayed(Duration(milliseconds: 1));
      if (Navigator.of(context).canPop()) Navigator.pop(context, data);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesProvider>(
            builder: (_) => favoritesProvider.copy()),
        ChangeNotifierProvider<ThemeProvider>(
            builder: (_) => darkModeProvider.copy()),
        ChangeNotifierProvider<BlurProvider>(
            builder: (_) => blurProvider.copy()),
        ChangeNotifierProvider<TextSizeProvider>(
            builder: (_) => textSizeProvider.copy()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, _) {
          ThemeData overrideTheme;
          final dark = Constants.themeDataDark.copyWith(
              accentColor: provider.accentColor);
          final light = Constants.themeDataLight.copyWith(
              accentColor: provider.accentColor);

          if (provider.isDarkMode) {
            overrideTheme = dark;
          } else {
            overrideTheme = light;
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: Constants.themeDataDark,
            theme: overrideTheme,
            home: Scaffold(
              body: CardContent(textContent: textContent, exit: exit),
              drawer: TextAppDrawer(),
            ),
          );
        },
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Content textContent;
  final Function exit;

  CardContent({@required this.textContent, @required this.exit});

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
        Align(
          alignment: Alignment.bottomCenter,
          child: LayoutBuilder(
              builder: (context, contraints) =>
                  AbsorbPointer(
                    child: Container(
                      width: contraints.maxWidth,
                      height: 50.0,
                    ),
                  )),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      textContent.hasText
                          ? Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: TextSizeButton())
                          : NullWidget(),
                      textContent.hasMusic
                          ? Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child:
                              PlaybackButton(url: textContent.music)))
                          : Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 5.0),
                        child: FavoriteFAB(
                            title: textContent.title,
                            path: textContent.textPath),
                      ),
                    ],
                  ),
                ),
              ],
            )),
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
  final Content textContent;

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
          .of<ThemeProvider>(context)
          .info,
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
                  key: Key(Random().toString()),
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
                              widget.textContent.hasText
                                  ? RichText(
                                  text: (TextSpan(
                                      children: widget.textContent
                                          .formattedText(textTheme.body1
                                          .copyWith(
                                          fontSize:
                                          Provider
                                              .of<TextSizeProvider>(
                                              context)
                                              .textSize *
                                              4.5)))))
                                  : NullWidget(),
                              SizedBox(
                                  height: 55,
                                  child: Center(
                                      child: Text(widget.textContent.date,
                                          style: textTheme.title))),
                              widget.textContent.hasMusic
                                  ? SizedBox(height: 55)
                                  : NullWidget(),
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
