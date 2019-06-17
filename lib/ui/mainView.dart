import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textos/constants.dart';
import 'package:textos/text_icons_icons.dart';
import 'package:textos/ui/authorsView.dart';
import 'package:textos/ui/backdrop.dart';
import 'package:textos/ui/favoritesView.dart';
import 'package:textos/ui/settingsView.dart';
import 'package:textos/ui/textsView.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isList;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _isList = false;
    super.initState();
  }

  String get currentTitle {
    switch (_tabController.animation.value.round()) {
      case 0:
        return textAuthors;
        break;
      case 1:
        return textTexts;
        break;
      case 2:
        return textFavs;
        break;
      default:
        return 'App';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData actualTheme = Theme.of(context);
    Brightness inverseOf(Brightness b) =>
        b == Brightness.dark ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: actualTheme.primaryColor,
        systemNavigationBarIconBrightness:
            inverseOf(actualTheme.primaryColorBrightness),
        statusBarColor: actualTheme.brightness == Brightness.dark
            ? Colors.black.withAlpha(100)
            : Colors.white.withAlpha(100),
        statusBarIconBrightness: inverseOf(actualTheme.brightness)));

    //SystemChrome.setEnabledSystemUIOverlays(
    //    <SystemUiOverlay>[SystemUiOverlay.bottom]);
    Widget _renderChild(Widget child, {BoxConstraints constraints}) =>
        RepaintBoundary(
            child: OverflowBox(
          alignment: Alignment.topCenter,
          minHeight:
              constraints.maxHeight - 42 - MediaQuery.of(context).padding.top,
          minWidth: constraints.maxWidth,
          maxHeight:
              constraints.maxHeight - 42 - MediaQuery.of(context).padding.top,
          maxWidth: constraints.maxWidth,
          child: child,
        ));

    const double spacerSize = 48;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Backdrop(
            frontAction: AnimatedBuilder(
                animation: _tabController.animation,
                builder: (BuildContext context, _) {
                  return _tabController.animation.value.round() == 1
                      ? Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(90),
                                      shape: BoxShape.circle),
                                  height: 2 * 42 / 3,
                                  width: 2 * 42 / 3),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(80.0),
                              color: Colors.transparent,
                              clipBehavior: Clip.antiAlias,
                              child: IconButton(
                                  icon: const Icon(Icons.list),
                                  tooltip: textTooltipTabPageToggle,
                                  onPressed: () =>
                                      setState(() => _isList = !_isList)),
                            ),
                          ],
                        )
                      : const SizedBox();
                }),
            frontTitle: RepaintBoundary(
                child: AnimatedBuilder(
                    animation: _tabController.animation,
                    builder: (BuildContext context, _) => Text(currentTitle))),
            frontLayer: RepaintBoundary(
                child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _renderChild(
                    AuthorsView(
                      isVisible: _tabController.animation.value.floor() == 0 ||
                          _tabController.animation.value.ceil() == 0,
                    ),
                    constraints: constraints),
                _renderChild(TextsView(spacerSize: spacerSize, isList: _isList),
                    constraints: constraints),
                _renderChild(
                    FavoritesView(spacerSize: spacerSize, isList: _isList),
                    constraints: constraints),
              ],
            )),
            backTitle: const Text(textSettings),
            backLayer: SettingsView(),
            frontHeading: Container(
                height: spacerSize,
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Container(
                            decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color.alphaBlend(Theme.of(context).primaryColor.withAlpha(90), Theme.of(context).backgroundColor)),
                            height: 2 * 42 / 3,
                            width: 2 * 42 / 3)),
                    Center(child: const Icon(Icons.keyboard_arrow_down)),
                  ],
                ))),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _tabController.animation,
          builder: (BuildContext context, _) => Stack(
                children: <Widget>[
                  BottomNavigationBar(
                      onTap: (int idx) => _tabController.animateTo(idx),
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: true,
                      showUnselectedLabels: false,
                      currentIndex: _tabController.animation.value.round(),
                      selectedItemColor: Color.alphaBlend(
                          Theme.of(context).accentColor.withAlpha(120),
                          Theme.of(context).backgroundColor),
                      unselectedItemColor: Theme.of(context).backgroundColor,
                      backgroundColor: Theme.of(context).primaryColor,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            activeIcon: Icon(TextIcons.account_group),
                            icon: Icon(TextIcons.account_group_outline),
                            title: Text(textAuthors)),
                        BottomNavigationBarItem(
                            activeIcon: Icon(TextIcons.book_open_page_variant),
                            icon: Icon(TextIcons.book_open_variant),
                            title: Text(textTexts)),
                        BottomNavigationBarItem(
                            activeIcon: Icon(TextIcons.heart_multiple),
                            icon: Icon(TextIcons.heart_multiple_outline),
                            title: Text(textFavs)),
                      ]),
                  SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0, 0),
                              end: const Offset(1.0, 0.0))
                          .animate(_tabController.animation),
                      child: FractionallySizedBox(
                        widthFactor: 1 / _tabController.length,
                        child: Container(
                          margin: const EdgeInsets.only(top: 54.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(1.0)),
                          height: 2.0,
                        ),
                      ))
                ],
              ),
        ),
      ),
    );
  }
}
