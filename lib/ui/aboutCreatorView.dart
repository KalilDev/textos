import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/widgets.dart';

class CreatorView extends StatelessWidget {
  const CreatorView(
      {Key key,
      @required this.darkModeProvider,
      @required this.textSizeProvider,
      @required this.blurProvider,
      @required this.favoritesProvider})
      : super(key: key);

  final ThemeProvider darkModeProvider;
  final BlurProvider blurProvider;
  final TextSizeProvider textSizeProvider;
  final FavoritesProvider favoritesProvider;

  @override
  Widget build(BuildContext context) {
    Future<bool> exit(List data) async {
      HapticFeedback.selectionClick();
      // Nasty
      await Future.delayed(Duration(milliseconds: 1));
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context, data);
        return false;
      } else {
        return false;
      }
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
              .copyWith(accentColor: provider.accentColor);
          final light = Constants.themeDataLight
              .copyWith(accentColor: provider.accentColor);

          if (provider.isDarkMode) {
            overrideTheme = dark;
          } else {
            overrideTheme = light;
          }
          return WillPopScope(
            onWillPop: () async {
              return exit([
                Provider.of<FavoritesProvider>(context).favoritesList,
                Provider.of<ThemeProvider>(context).info,
                Provider.of<BlurProvider>(context).blurSettings,
                Provider.of<TextSizeProvider>(context).textSize
              ]);
            },
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                darkTheme: Constants.themeDataDark,
                theme: overrideTheme,
                home: Scaffold(
                  body: AboutCreator(exitContext: context),
                )),
          );
        },
      ),
    );
  }
}

class AboutCreator extends StatelessWidget {
  final BuildContext exitContext;

  AboutCreator({@required this.exitContext});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: <Widget>[
        ElevatedContainer(
            elevation: 8.0,
            margin: EdgeInsets.fromLTRB(
                10.0, MediaQuery.of(context).padding.top, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ElevatedContainer(
                  elevation: 12.0,
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 100),
                      Material(
                        color: Colors.transparent,
                        elevation: 16.0,
                        shape: CircleBorder(),
                        child: ClipOval(
                          child: Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      'https://pbs.twimg.com/profile_images/1080927080458739714/2CVPlhXy_400x400.jpg'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: Text('Pedro Kalil',
                                    style: textTheme.display2)),
                            Center(
                                child: Text('Desenvolvedor do App',
                                    style: textTheme.subtitle))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          ElevatedContainer(
                              elevation: 12.0,
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Sobre Mim:',
                                      style: textTheme.subtitle,
                                      textAlign: TextAlign.start),
                                  Text(
                                    Constants.aboutMe,
                                    style: textTheme.subtitle,
                                  )
                                ],
                              )),
                          SizedBox(height: 10.0),
                          ElevatedContainer(
                              elevation: 12.0,
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Sobre o App:',
                                      style: textTheme.subtitle,
                                      textAlign: TextAlign.start),
                                  Text(
                                    Constants.aboutApp,
                                    style: textTheme.subtitle,
                                  )
                                ],
                              )),
                          SizedBox(height: 10.0),
                          ElevatedContainer(
                              elevation: 12.0,
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Sobre o Flutter:',
                                      style: textTheme.subtitle,
                                      textAlign: TextAlign.start),
                                  Text(
                                    Constants.aboutFlutter,
                                    style: textTheme.subtitle,
                                  )
                                ],
                              )),
                          SizedBox(height: 10.0),
                          Container(
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text(Constants.aboutGreeting,
                                      style: textTheme.title,
                                      textAlign: TextAlign.start),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
        Positioned(
          child: MenuButton(data: [
            Provider.of<FavoritesProvider>(context).favoritesList,
            Provider.of<ThemeProvider>(context).info,
            Provider.of<BlurProvider>(context).blurSettings,
            Provider.of<TextSizeProvider>(context).textSize
          ], exitContext: exitContext),
          top: MediaQuery.of(context).padding.top - 2.5,
          left: -2.5,
        ),
      ],
    );
  }
}
