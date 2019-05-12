import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:textos/Src/TextContent.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/Widgets/Widgets.dart';

class StoryPages extends StatefulWidget {
  final List slideList;

  StoryPages({@required this.slideList});

  @override
  _StoryPagesState createState() => _StoryPagesState();
}

class _StoryPagesState extends State<StoryPages> {
  PageController _storiesPageController;
  PageController _tagPageController;

  @override
  void initState() {
    super.initState();
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
    return PageView.builder(
        controller: _storiesPageController,
        itemCount: widget.slideList.length + 1,
        pageSnapping: false,
        itemBuilder: (context, int currentIdx) {
          if (currentIdx == 0) {
            return TagPages(tagPageController: _tagPageController);
          } else {
            final data = widget.slideList[currentIdx - 1];
            return _StoryPage(
                index: currentIdx,
                textContent: TextContent.fromData(data),
                pageController: _storiesPageController);
          }
        });
  }
}

class _StoryPage extends StatelessWidget {
  final TextContent textContent;
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
                        color: Theme.of(context).primaryColor.withAlpha(80),
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
                        enabled: Provider.of<BlurProvider>(context).textsBlur,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 5.0),
                            Text(textContent.title,
                                textAlign: TextAlign.center,
                                style: textTheme.display1),
                            SizedBox(width: 5.0)
                          ],
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
          if (pageController != null)
            pageController.animateToPage(index,
                duration: Constants.durationAnimationMedium,
                curve: Curves.decelerate);
          final result = await Navigator.push(
              context,
              FadeRoute(
                  builder: (context) => TextCardView(
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
