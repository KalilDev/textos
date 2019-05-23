import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/drawer/drawer.dart';

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
          final dark = Constants.themeDataDark
              .copyWith(primaryColor: provider.darkPrimaryColor);
          final light = Constants.themeDataLight
              .copyWith(primaryColor: provider.lightPrimaryColor);

          if (provider.isDarkMode) {
            overrideTheme = dark;
          } else {
            overrideTheme = light;
          }
          return WillPopScope(
            onWillPop: () async {
              return exit([
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
            },
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                darkTheme: Constants.themeDataDark,
                theme: overrideTheme,
                home: Scaffold(
                  body: CardContent(
                      textContent: textContent, exitContext: context),
                  drawer: TextAppDrawer(),
                )),
          );
        },
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final Content textContent;
  final BuildContext exitContext;

  CardContent({@required this.textContent, @required this.exitContext});

  @override
  Widget build(BuildContext context) {
    exit(List data) async {
      HapticFeedback.selectionClick();
      // Nasty
      await Future.delayed(Duration(milliseconds: 1));
      if (Navigator.of(exitContext).canPop()) Navigator.pop(exitContext, data);
    }
    return Stack(
      children: <Widget>[
        Hero(
            tag: 'image' + textContent.textPath,
            child: ImageBackground(
                img: textContent.imgUrl,
                enabled: false,
                key: Key('image' + textContent.textPath))),
        _TextWidget(
          exit: exit,
          textContent: textContent,
        ),
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
                          child: IncDecButton(
                              isBlurred: Provider
                                  .of<BlurProvider>(context)
                                  .buttonsBlur,
                              onDecrease: () =>
                                  Provider.of<TextSizeProvider>(context)
                                      .decrease(),
                              onIncrease: () =>
                                  Provider.of<TextSizeProvider>(context)
                                      .increase(),
                              value: Provider
                                  .of<TextSizeProvider>(context)
                                  .textSize))
                          : SizedBox(),
                      textContent.hasMusic
                          ? Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child:
                              PlaybackButton(
                                url: textContent.music, isBlurred: Provider
                                  .of<BlurProvider>(context)
                                  .buttonsBlur,)))
                          : Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 5.0),
                        child: BiStateFAB(
                          onPressed: () =>
                              Provider.of<FavoritesProvider>(context).toggle(
                                  textContent.title + ';' +
                                      textContent.textPath),
                          isBlurred: Provider
                              .of<BlurProvider>(context)
                              .buttonsBlur,
                          isEnabled: Provider.of<FavoritesProvider>(context)
                              .isFavorite(
                              textContent.title + ';' + textContent.textPath),),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Positioned(
          child: MenuButton(data: [
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
          ], exitContext: exitContext),
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
  final Function exit;
  final Content textContent;

  _TextWidget({
    @required this.exit,
    @required this.textContent});

  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget>
    with TickerProviderStateMixin {
  double _textSize;
  AnimationController _textSizeController;
  Animation<double> _textSizeAnim;

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
    _textSizeController = new AnimationController(
        vsync: this, duration: Constants.durationAnimationShort);
    _textSizeAnim = new CurvedAnimation(
        parent: _textSizeController, curve: Curves.easeInOut);
    _textSize = 4.5;
    _textSizeController.addListener(() {
      if (_textSizeController.status == AnimationStatus.completed) {
        _textSize = Provider
            .of<TextSizeProvider>(context)
            .textSize;
        _textSizeController.value = 0.0;
      }
      setState(() => null);
    });
    _textSizeController.value = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider
        .of<TextSizeProvider>(context)
        .textSize != _textSize) {
      _textSizeController.forward();
    }
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
                child: BlurOverlay.roundedRect(
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
                                          .formattedText(
                                          textTheme.body1.copyWith(
                                              fontSize: Tween(
                                                  begin: _textSize,
                                                  end: Provider
                                                      .of<
                                                      TextSizeProvider>(
                                                      context)
                                                      .textSize)
                                                  .animate(
                                                  _textSizeAnim)
                                                  .value *
                                                  4.5)))))
                                  : SizedBox(),
                              SizedBox(
                                  height: 55,
                                  child: Center(
                                      child: Text(widget.textContent.date,
                                          style: textTheme.title))),
                              widget.textContent.hasMusic
                                  ? SizedBox(height: 55)
                                  : SizedBox(),
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
