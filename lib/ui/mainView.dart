import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:textos/bloc/database_stream_manager/bloc.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
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
    _tabController = TabController(length: 3, vsync: this);
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

    Widget _textsView() {
      final String authorID = Provider.of<QueryInfoProvider>(context).collection;
      final String tag = Provider.of<QueryInfoProvider>(context).tag;
      return BlocProvider<DatabaseAuthorStreamManagerBloc>(
        builder: (BuildContext context) => BlocProvider.of<DatabaseStreamManagerBloc>(context).getTextBloc(authorID, tag: tag),
        child: Builder(
          builder: (BuildContext context) => BlocBuilder<DatabaseAuthorStreamManagerEvent, DatabaseAuthorStreamManagerState>(
              bloc: BlocProvider.of<DatabaseAuthorStreamManagerBloc>(context),
              builder: (BuildContext context, DatabaseAuthorStreamManagerState state) {
                if (state is LoadedTextsStream)
                  return const TextsView(spacerSize: spacerSize);
                return Center(child: const CircularProgressIndicator());
              }
          ),
        ),
      );
    }

    return BlocProvider<DatabaseStreamManagerBloc>(
        builder: (BuildContext context) => DatabaseStreamManagerBloc(),
        child: Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                Backdrop(
                    frontTitle: RepaintBoundary(
                        child: AnimatedBuilder(
                            animation: _tabController.animation,
                            builder: (BuildContext context, _) =>
                                Text(currentTitle))),
                    frontLayer: RepaintBoundary(
                        child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        _renderChild(AuthorsView(), constraints: constraints),
                        _renderChild(_textsView(),
                            constraints: constraints),
                        _renderChild(
                            const FavoritesView(spacerSize: spacerSize),
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
                                        color: Color.alphaBlend(
                                            Theme.of(context)
                                                .accentColor
                                                .withAlpha(90),
                                            Theme.of(context).backgroundColor)),
                                    height: 2 * 42 / 3,
                                    width: 2 * 42 / 3)),
                            Center(
                                child: const Icon(Icons.keyboard_arrow_down)),
                          ],
                        ))),
          ),
          bottomNavigationBar: RepaintBoundary(
            child: Material(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                  controller: _tabController,
                  labelColor: Color.alphaBlend(
                      Theme.of(context).accentColor.withAlpha(120),
                      actualTheme.backgroundColor),
                  unselectedLabelColor: actualTheme.backgroundColor,
                  unselectedLabelStyle: Theme.of(context).accentTextTheme.body2,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: actualTheme.colorScheme.secondaryVariant,
                  labelStyle: Theme.of(context)
                      .accentTextTheme
                      .body2
                      .copyWith(fontWeight: FontWeight.bold),
                  tabs: const <Widget>[
                    Tab(text: textAuthors, icon: Icon(TextIcons.account_group)),
                    Tab(
                        text: textTexts,
                        icon: Icon(TextIcons.book_open_page_variant)),
                    Tab(text: textFavs, icon: Icon(TextIcons.heart_multiple)),
                  ]),
            ),
          ),
        ));
  }
}
