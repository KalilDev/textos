import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/mixins.dart';
import 'package:textos/src/providers.dart';

class CreatorView extends StatelessWidget with Haptic {
  const CreatorView({Key key, @required this.darkModeProvider})
      : super(key: key);

  final ThemeProvider darkModeProvider;

  @override
  Widget build(BuildContext context) {
    Future<bool> exit(List<dynamic> data) async {
      selectItem();
      // Nasty
      await Future
      <
      void
      >
          .
      delayed
      (
      const
      Duration
      (
      milliseconds
          :
      1
      )
      );
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context, data);
        return false;
      } else {
        return false;
      }
    }

    return Provider<ThemeProvider>(
      builder: (_) => darkModeProvider.copy(),
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider provider, _) {
          ThemeData overrideTheme;
          final ThemeData dark =
          themeDataDark.copyWith(primaryColor: provider.darkPrimaryColor);
          final ThemeData light =
          themeDataLight.copyWith(primaryColor: provider.lightPrimaryColor);

          if (provider.isDarkMode) {
            overrideTheme = dark;
          } else {
            overrideTheme = light;
          }
          return WillPopScope(
            onWillPop: () async {
              return exit(<dynamic>[
                Provider.of<FavoritesProvider>(context).favoritesList,
                Provider.of<ThemeProvider>(context).info,
                Provider.of<BlurProvider>(context).blurSettings,
                Provider.of<TextSizeProvider>(context).textSize
              ]);
            },
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                darkTheme: themeDataDark,
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
  const AboutCreator({@required this.exitContext});

  final BuildContext exitContext;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final TextTheme accentTextTheme = Theme
        .of(context)
        .accentTextTheme;
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ElevatedContainer(
                  elevation: 12.0,
                  elevatedColor: Theme
                      .of(context)
                      .primaryColor,
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      const SizedBox(height: 100),
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
                                child: Text(
                                  'Pedro Kalil',
                                  style: accentTextTheme.display1,
                                  textAlign: TextAlign.center,
                                )),
                            Center(
                                child: Text(
                                  'Desenvolvedor do App',
                                  style: accentTextTheme.subtitle,
                                  textAlign: TextAlign.center,
                                ))
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
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          ElevatedContainer(
                              elevation: 12.0,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Sobre Mim:',
                                      style: textTheme.subtitle,
                                      textAlign: TextAlign.start),
                                  Text(
                                    aboutMe,
                                    style: textTheme.subtitle,
                                  )
                                ],
                              )),
                          const SizedBox(height: 10.0),
                          ElevatedContainer(
                              elevation: 12.0,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Sobre o App:',
                                      style: textTheme.subtitle,
                                      textAlign: TextAlign.start),
                                  Text(
                                    aboutApp,
                                    style: textTheme.subtitle,
                                  )
                                ],
                              )),
                          const SizedBox(height: 10.0),
                          ElevatedContainer(
                              elevation: 12.0,
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Sobre o Flutter:',
                                      style: textTheme.subtitle,
                                      textAlign: TextAlign.start),
                                  Text(
                                    aboutFlutter,
                                    style: textTheme.subtitle,
                                  )
                                ],
                              )),
                          const SizedBox(height: 10.0),
                          Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text(aboutGreeting,
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
          child: MenuButton(data: <dynamic>[
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
