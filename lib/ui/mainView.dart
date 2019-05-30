import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            Backdrop(
                frontTitle: const Text('Textos'),
                frontLayer: RepaintBoundary(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        FavoritesView(), AuthorsView(), TextsView()],
                    )),
                backTitle: const Text('Configurações'),
                backLayer: SettingsView()),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _tabController.animation,
          builder: (BuildContext context, _) =>
              Stack(
                children: <Widget>[
                  BottomNavigationBar(
                      onTap: (int idx) => _tabController.animateTo(idx),
                      type: BottomNavigationBarType.fixed,
                      showSelectedLabels: true,
                      showUnselectedLabels: false,
                      currentIndex: _tabController.animation.value.round(),
                      selectedItemColor: Color.alphaBlend(
                          Theme
                              .of(context)
                              .accentColor
                              .withAlpha(120),
                          Theme
                              .of(context)
                              .backgroundColor),
                      unselectedItemColor: Theme
                          .of(context)
                          .backgroundColor,
                      backgroundColor: Theme
                          .of(context)
                          .primaryColor,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(Icons.favorite),
                            title: Text('Favoritos')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.group), title: Text('Autores')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.style), title: Text('Textos')),
                      ]),
                  SlideTransition(
                      position: Tween<Offset>(
                          begin: const Offset(0, 0),
                          end: const Offset(1.0, 0.0))
                          .animate(_tabController.animation),
                      child: FractionallySizedBox(
                        widthFactor: 1 / 3,
                        child: Container(
                          margin: const EdgeInsets.only(top: 54.0),
                          color: Theme
                              .of(context)
                              .accentColor,
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
