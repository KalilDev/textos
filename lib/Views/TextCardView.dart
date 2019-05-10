import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class TextCardView extends StatelessWidget {
  // Declare a field that holds the data map, and a field that holds the index
  final Map data;
  final Store<AppStateMain> store;

  // In the constructor, require the data map and index
  TextCardView({@required this.data, this.store});

  @override
  Widget build(BuildContext context) {
    exit() {
      Navigator.pop(context);
    }

    ThemeData overrideTheme;
    if (store.state.enableDarkMode) {
      overrideTheme = Constants.themeDataDark;
    } else {
      overrideTheme = Constants.themeDataLight;
    }

    return MaterialApp(
        darkTheme: Constants.themeDataDark,
        theme: overrideTheme,
        home: new Scaffold(
            drawer: TextAppDrawer(store: store),
            body: new TextCard(data: data, store: store, exit: exit)));
  }
}

class TextCard extends StatelessWidget {
  const TextCard({
    Key key,
    @required this.data,
    @required this.store,
    @required this.exit,
  }) : super(key: key);

  final Map data;
  final Store<AppStateMain> store;
  final Function exit;

  @override
  Widget build(BuildContext context) {
    // Sanitize input
    final title = data['title'] ?? Constants.placeholderTitle;
    final text = data['text'] ?? Constants.placeholderText;
    final date = data['date'] ?? Constants.placeholderDate;
    final img = data['img'] ?? Constants.placeholderImg;

    final textTheme = Theme
        .of(context)
        .textTheme;

    return Stack(
      children: <Widget>[
        Dismissible(
          key: Key(title),
          movementDuration: Constants.durationAnimationShort,
          confirmDismiss: (callback) {
            if (callback == DismissDirection.startToEnd) {
              Scaffold.of(context).openDrawer();
            } else {
              exit();
            }
          },
          child: GestureDetector(
            onTap: () => exit(),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Hero(
                      tag: 'image' + data['path'],
                      child: ImageBackground(
                          img: img,
                          enabled: false,
                          key: Key('image' + data['path']))),
                  Hero(
                    tag: 'body' + data['path'],
                    child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: BlurOverlay(
                            enabled: BlurSettings(store.state.blurSettings)
                                .textsBlur,
                            radius: 20,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: SingleChildScrollView(
                                      child: Column(children: <Widget>[
                                        Text(title,
                                            textAlign: TextAlign.center,
                                            style: textTheme.display1),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(text,
                                            style: textTheme.body1.copyWith(
                                                fontSize: store.state.textSize *
                                                    4.5)),
                                        SizedBox(
                                          height: 55,
                                          child: Center(
                                            child: Text(date,
                                                style: textTheme.title),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    child: new FavoriteFAB(
                        store: store, title: title, path: data['path']),
                    right: 10,
                    bottom: 10,
                  ),
                  Positioned(
                    child: new TextSizeButton(store: store),
                    left: 10,
                    bottom: 13.5,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          child: MenuButton(),
          top: MediaQuery
              .of(context)
              .padding
              .top - 2.5,
          left: -2.5,
        ),
      ],
    );
  }
}
