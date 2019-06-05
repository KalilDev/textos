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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  String get currentTitle {
    switch (_tabController.animation.value.round()) {
      case 0:
        return textFavs;
        break;
      case 1:
        return textAuthors;
        break;
      case 2:
        return textTexts;
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
    Widget _renderChild(Widget child, {BoxConstraints constraints}) => RepaintBoundary(
        child: OverflowBox(
          minHeight: constraints.maxHeight -
              42 -
              MediaQuery.of(context).padding.top,
          minWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight -
              42 -
              MediaQuery.of(context).padding.top,
          maxWidth: constraints.maxWidth,
          child: child,
        ));

    const double spacerSize = 32;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Backdrop(
            frontTitle: RepaintBoundary(
                child: AnimatedBuilder(
                    animation: _tabController.animation,
                    builder: (BuildContext context, _) => Text(currentTitle))),
            frontLayer: RepaintBoundary(
                child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _renderChild(const FavoritesView(spacerSize: spacerSize), constraints: constraints),
                _renderChild(AuthorsView(
                  isVisible:
                  _tabController.animation.value.floor() == 1 ||
                      _tabController.animation.value.ceil() == 1,
                ), constraints: constraints),
                _renderChild(TextsView(), constraints: constraints)
              ],
            )),
            backTitle: const Text(textConfigs),
            backLayer: SettingsView(),
            frontHeading: Container(height: spacerSize)),
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
                            activeIcon: Icon(TextIcons.heart_multiple),
                            icon: Icon(TextIcons.heart_multiple_outline),
                            title: Text(textFavs)),
                        BottomNavigationBarItem(
                            activeIcon: Icon(TextIcons.account_group),
                            icon: Icon(TextIcons.account_group_outline),
                            title: Text(textAuthors)),
                        BottomNavigationBarItem(
                            activeIcon: Icon(TextIcons.book_open_page_variant),
                            icon: Icon(TextIcons.book_open_variant),
                            title: Text(textTexts)),
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
                              color: Color.alphaBlend(
                                  Theme.of(context).accentColor.withAlpha(120),
                                  Theme.of(context).backgroundColor),
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
