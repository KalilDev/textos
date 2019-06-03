import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:textos/constants.dart';
import 'package:textos/text_icons_icons.dart';

class CreatorView extends StatelessWidget {
  const CreatorView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AboutCreator(),
    );
  }
}

class AboutCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextTheme accentTextTheme = Theme.of(context).accentTextTheme;
    const double kElevation = 6.0;
    return Material(
      elevation: 0.0,
      child: Stack(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Hero(
                tag: 'about',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ElevatedContainer(
                      elevation: kElevation,
                      elevatedColor: Theme.of(context).primaryColor,
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const SizedBox(height: 100),
                          Material(
                            color: Colors.transparent,
                            elevation: kElevation + 4,
                            shape: CircleBorder(),
                            child: ClipOval(
                              child: Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        child: Center(
                                            child: Icon(
                                          TextIcons.account,
                                          size: 72,
                                          color:
                                              Theme.of(context).backgroundColor,
                                        )),
                                      ),
                                      CachedNetworkImage(
                                          imageUrl:
                                              'https://pbs.twimg.com/profile_images/1080927080458739714/2CVPlhXy_400x400.jpg'),
                                    ],
                                  ),
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
                      child: RepaintBoundary(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                ElevatedContainer(
                                    elevation: kElevation,
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
                                    elevation: kElevation,
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
                                    elevation: kElevation,
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
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
            child: MenuButton(),
            top: MediaQuery.of(context).padding.top - 2.5,
            left: -2.5,
          ),
        ],
      ),
    );
  }
}
