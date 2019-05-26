import 'package:flutter/material.dart';
import 'package:textos/ui/authorsView.dart';
import 'package:textos/ui/backdrop.dart';
import 'package:textos/ui/favoritesView.dart';
import 'package:textos/ui/settingsView.dart';
import 'package:textos/ui/textsView.dart';

import 'bottomTextsBar.dart';

class TabNavigatorRoutes {
  static const String authors = '/authors';
  static const String texts = '/texts';
  static const String favs = '/favorites';
}

class MainNavigator extends StatelessWidget {
  final GlobalKey navigatorKey;
  final Widget child;
  final String name;

  MainNavigator(
      {@required this.navigatorKey, @required this.child, @required this.name});

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        initialRoute: name,
        observers: [HeroController()],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => child,
          );
        });
  }
}

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIdx;

  @override
  void initState() {
    _currentIdx = 1;
    super.initState();
  }

  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    TabNavigatorRoutes.favs: GlobalKey<NavigatorState>(),
    TabNavigatorRoutes.authors: GlobalKey<NavigatorState>(),
    TabNavigatorRoutes.texts: GlobalKey<NavigatorState>(),
  };

  Widget _buildOffstageNavigator(int index, {Widget child, String name}) {
    return Offstage(
      offstage: _currentIdx != index,
      child: MainNavigator(
          navigatorKey: navigatorKeys[name], name: name, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => Backdrop(
              frontTitle: Text('Textos'),
              frontLayer: ListView(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight - 40,
                    child: RepaintBoundary(
                        child: Stack(
                      children: <Widget>[
                        _buildOffstageNavigator(0,
                            child: FavoritesView(),
                            name: TabNavigatorRoutes.favs),
                        _buildOffstageNavigator(1,
                            child: AuthorsView(),
                            name: TabNavigatorRoutes.authors),
                        _buildOffstageNavigator(2,
                            child: TextsView(), name: TabNavigatorRoutes.texts)
                      ],
                    )),
                  )
                ],
              ),
              backTitle: Text('Configurações'),
              backLayer: SettingsView()),
        ),
        bottomNavigationBar: BottomTextsBar(
          currentIdx: _currentIdx,
          onTap: (index) => setState(() => _currentIdx = index),
        ));
  }
}
