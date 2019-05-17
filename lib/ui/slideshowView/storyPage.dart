import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView/cardView.dart';
import 'package:textos/ui/slideshowView/favoritesCount.dart';
import 'package:textos/ui/slideshowView/tagPage.dart';
import 'package:textos/ui/widgets.dart';

class StoryPages extends StatefulWidget {
  final List slideList;

  StoryPages({@required this.slideList});

  @override
  _StoryPagesState createState() => _StoryPagesState();
}

class _StoryPagesState extends State<StoryPages> with TickerProviderStateMixin {
  PageController _storiesPageController;
  PageController _tagPageController;
  AnimationController _animationController;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Constants.durationAnimationShort);
    _opacity =
    new CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.addListener(() {
      if (_animationController.status ==
          AnimationStatus.dismissed) _animationController.forward();
    });
    _animationController.value = 1.0;
    _storiesPageController = new PageController(viewportFraction: 0.85);
    _tagPageController = new PageController(viewportFraction: 0.90);
    _storiesPageController.addListener(() {
      int next = _storiesPageController.page.round();
      if (_tagPageController.hasClients) {
        Provider.of<QueryProvider>(context).jump(_tagPageController);
      }
      if (Provider
          .of<TextPageProvider>(context)
          .currentPage != next) {
        HapticFeedback.lightImpact();
        Provider.of<TextPageProvider>(context).currentPage = next;
      }
    });
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
    return PageView.builder(
        controller: _storiesPageController,
        itemCount: widget.slideList.length + 1,
        pageSnapping: false,
        itemBuilder: (context, int currentIdx) {
          if (currentIdx == 0) {
            return TagPages(tagPageController: _tagPageController);
          } else {
            final data = widget.slideList[currentIdx - 1];
            return ScaleTransition(
              scale: Tween(begin: 1.1, end: 1.0).animate(_opacity),
              child: FadeTransition(
                opacity: Tween(begin: 0.7, end: 1.0).animate(_opacity),
                child: _StoryPage(
                    index: currentIdx,
                    textContent: Content.fromData(data),
                    pageController: _storiesPageController),
              ),
            );
          }
        });
  }
}

class _StoryPage extends StatelessWidget {
  final Content textContent;
  final int index;
  final PageController pageController;

  _StoryPage(
      {@required this.index, @required this.textContent, this.pageController});

  @override
  Widget build(BuildContext context) {
    bool active = index == Provider.of<TextPageProvider>(context).currentPage;
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? MediaQuery.of(context).padding.top + 60 : 180;

    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Constants.durationAnimationMedium,
              curve: Curves.decelerate,
              margin: EdgeInsets.only(top: top, bottom: 20, right: 30),
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
                      key: Key('image' + textContent.textPath))),
            ),
            AnimatedContainer(
              duration: Constants.durationAnimationLong,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: top, bottom: 20, right: 30),
              child: Center(
                  child: Hero(
                tag: 'body' + textContent.textPath,
                child: Material(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(12.5),
                    child: BlurOverlay(
                        radius: 15,
                        enabled: Provider
                            .of<BlurProvider>(context)
                            .buttonsBlur,
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(textContent.title,
                              textAlign: TextAlign.center,
                              style: textTheme.display1),
                        )),
                  ),
                  color: Colors.transparent,
                ),
              )),
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
                child: active
                    ? Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: FavoritesCount(
                        favorites: textContent.favoriteCount,
                        text:
                        textContent.title + ';' + textContent.textPath,
                        blurEnabled:
                        Provider
                            .of<BlurProvider>(context)
                            .textsBlur))
                    : NullWidget())
          ],
        ),
        onTap: () async {
          HapticFeedback.selectionClick();
          if (pageController != null)
            pageController.animateToPage(index,
                duration: Constants.durationAnimationMedium,
                curve: Curves.decelerate);
          final result = await Navigator.push(
              context,
              FadeRoute(
                  builder: (context) =>
                      CardView(
                        blurProvider: Provider.of<BlurProvider>(context),
                        darkModeProvider:
                        Provider.of<DarkModeProvider>(context),
                        textSizeProvider:
                        Provider.of<TextSizeProvider>(context),
                        favoritesProvider:
                        Provider.of<FavoritesProvider>(context),
                        textContent: textContent,
                      )));
          List resultList = result;
          Provider.of<FavoritesProvider>(context).sync(resultList[0]);
          Provider.of<DarkModeProvider>(context).sync(resultList[1]);
          Provider.of<BlurProvider>(context).sync(resultList[2]);
          Provider.of<TextSizeProvider>(context).sync(resultList[3]);
        });
  }
}
