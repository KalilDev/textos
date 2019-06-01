import 'package:flutter/material.dart';
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
                RepaintBoundary(child: FavoritesView()),
                RepaintBoundary(
                    child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                      Container(
                          height: constraints.maxHeight -
                              48 -
                              MediaQuery.of(context).padding.top,
                          child: AuthorsView())
                    ])),
                RepaintBoundary(
                    child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                      Container(
                          height: constraints.maxHeight -
                              48 -
                              MediaQuery.of(context).padding.top,
                          child: TextsView())
                    ]))
              ],
            )),
            backTitle: const Text(textConfigs),
            backLayer: SettingsView()),
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
