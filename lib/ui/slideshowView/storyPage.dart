import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView/cardView.dart';
import 'package:textos/ui/slideshowView/favoritesCount.dart';
import 'package:textos/ui/slideshowView/tagPage.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class StoryPages extends StatefulWidget {
  final List slideList;

  StoryPages({@required this.slideList});

  @override
  _StoryPagesState createState() => _StoryPagesState();
}

class _StoryPagesState extends State<StoryPages> with TickerProviderStateMixin {
  IndexController _indexController;
  AnimationController _animationController;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Constants.durationAnimationShort);
    _opacity = new CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOut);
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.dismissed)
        _animationController.forward();
    });
    _animationController.value = 1.0;
    _indexController = new IndexController();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider
        .of<QueryProvider>(context)
        .shouldAnimate) {
      Provider
          .of<QueryProvider>(context)
          .shouldAnimate = false;
      _animationController.reverse();
    }
    return new TransformerPageView(
      pageSnapping: false,
      controller: _indexController,
      viewportFraction: 0.80,
      curve: Curves.decelerate,
      physics: BouncingScrollPhysics(),
      transformer: new PageTransformerBuilder(
          builder: (Widget child, TransformInfo info) {
            if (info.index == 0) {
              return TagPages();
            } else {
              final data = widget.slideList[info.index - 1];
              return ScaleTransition(
                scale: Tween(begin: 1.1, end: 1.0).animate(_opacity),
                child: FadeTransition(
                  opacity: Tween(begin: 0.7, end: 1.0).animate(_opacity),
                  child: _StoryPage(
                      info: info,
                      textContent: Content.fromData(data),
                      indexController: _indexController),
                ),
              );
            }
          }),
      onPageChanged: (page) {
        HapticFeedback.lightImpact();
      },
      itemCount: widget.slideList.length + 1,
    );
  }
}

class _StoryPage extends StatelessWidget {
  final Content textContent;
  final TransformInfo info;
  final IndexController indexController;

  _StoryPage(
      {@required this.info, @required this.textContent, this.indexController});

  @override
  Widget build(BuildContext context) {
    final bool active = info.position.round() == 0.0 && info.position >= -0.35;
    // Animated Properties
    final double blur = lerpDouble(30, 0, info.position.abs());
    final double offset = lerpDouble(20, 0, info.position.abs());
    final double top = MediaQuery
        .of(context)
        .padding
        .top + 60;

    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Constants.durationAnimationMedium,
              curve: Curves.decelerate,
              margin: EdgeInsets.only(
                  top: active ? top : 180, bottom: 20, right: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(80),
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              child: Hero(
                  tag: 'image' + textContent.textPath,
                  child: ImageBackground(
                      img: textContent.imgUrl,
                      enabled: false,
                      position: info.position,
                      key: Key('image' + textContent.textPath))),
            ),
            AnimatedContainer(
              duration: Constants.durationAnimationMedium,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(
                  top: active ? top : 180, bottom: 20, right: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ParallaxContainer(
                  position: info.position,
                  translationFactor: 300,
                  child: Align(
                      alignment: Alignment.center,
                      child: Hero(
                        tag: 'body' + textContent.textPath,
                        child: Material(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.all(12.5),
                            child: BlurOverlay.roundedRect(
                                radius: 15,
                                enabled:
                                Provider
                                    .of<BlurProvider>(context)
                                    .textsBlur,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: Text(textContent.title,
                                      textAlign: TextAlign.center,
                                      style: textTheme.display1),
                                )),
                          ),
                          color: Colors.transparent,
                        ),
                      )),
                ),
              ),
            ),
            AnimatedSwitcher(
                duration: Constants.durationAnimationShort,
                switchInCurve: Curves.decelerate,
                switchOutCurve: Curves.decelerate,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                  alignment: FractionalOffset.bottomCenter,
                ),
                child: info.position.round() == 0.0
                    ? Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: FavoritesCount(
                        favorites: textContent.favoriteCount,
                        text:
                        textContent.title + ';' + textContent.textPath,
                        blurEnabled:
                        Provider
                            .of<BlurProvider>(context)
                            .buttonsBlur))
                    : SizedBox())
          ],
        ),
        onTap: () async {
          HapticFeedback.selectionClick();
          if (indexController != null) indexController.move(info.index);
          final result = await Navigator.push(
              context,
              FadeRoute(
                  builder: (context) =>
                      CardView(
                        blurProvider: Provider.of<BlurProvider>(context),
                        darkModeProvider: Provider.of<ThemeProvider>(context),
                        textSizeProvider:
                        Provider.of<TextSizeProvider>(context),
                        favoritesProvider:
                        Provider.of<FavoritesProvider>(context),
                        textContent: textContent,
                      )));
          List resultList = result;
          Provider.of<FavoritesProvider>(context).sync(resultList[0]);
          Provider.of<ThemeProvider>(context).sync(resultList[1]);
          Provider.of<BlurProvider>(context).sync(resultList[2]);
          Provider.of<TextSizeProvider>(context).sync(resultList[3]);
        });
  }
}
