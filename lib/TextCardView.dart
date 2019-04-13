import'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/Drawer.dart';
import 'package:textos/SettingsHelper.dart';
import 'package:textos/main.dart';


class TextCard extends StatelessWidget {
  // Declare a field that holds the data map, and a field that holds the index
  final Map map;
  final Store<AppStateMain> store;

  // In the constructor, require the data map and index
  TextCard({@required this.map, this.store});

  @override
  Widget build(BuildContext context) {
    final themeBackground = store.state.enableDarkMode ? Constants
        .themeBackgroundDark : Constants.themeBackgroundLight;
    final themeForeground = store.state.enableDarkMode ? Constants
        .themeForegroundDark : Constants.themeForegroundLight;

    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    // Sanitize input
    final title = map['title'] ?? Constants.placeholderTitle;
    final text = map['text'] ?? Constants.placeholderText;
    final date = map['date'] ?? Constants.placeholderDate;
    final img = map['img'] ?? Constants.placeholderImg;

    final double blur = 30;
    final double offset = Constants().reactiveSize(10, 1, height, width);
    return MaterialApp(
        theme: store.state.enableDarkMode
            ? Constants.themeDataDark
            : Constants.themeDataLight, home: new Scaffold(
        drawer: TextAppDrawer(store: store),
        body: GestureDetector(
            child: Hero(
                tag: map['title'],
                child: Container(
                  margin: EdgeInsets.only(
                      top: Constants().reactiveSize(50, 0, height, width),
                      bottom: Constants().reactiveSize(20, 0, height, width),
                      right: Constants().reactiveSize(20, 1, height, width),
                      left: Constants().reactiveSize(10, 1, height, width)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: themeBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(img),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: themeForeground.withAlpha(125),
                            blurRadius: blur,
                            offset: Offset(offset, offset))
                      ]),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: themeBackground.withAlpha(130)),
                      child:
                      /*new ClipRect(child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: */
                      Material(
                        child: Container(
                          margin: EdgeInsetsDirectional.fromSTEB(
                              Constants().reactiveSize(5, 1, height, width), 0,
                              Constants().reactiveSize(5, 1, height, width),
                              Constants().reactiveSize(5, 0, height, width)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Text(title, textAlign: TextAlign.center,
                                            style: Constants()
                                                .textstyleTitle(
                                                store.state.textSize,
                                                store.state.enableDarkMode)),
                                        SizedBox(
                                          height: Constants().reactiveSize(
                                              10, 0, height, width),),
                                        Text(text,
                                            style: Constants().textstyleText(
                                                store.state.textSize,
                                                store.state.enableDarkMode)),
                                      ],
                                    ),
                                  )),
                              Row(
                                children: <Widget>[
                                  Text(date,
                                      style: Constants().textstyleDate(
                                          store.state.textSize,
                                          store.state.enableDarkMode)),
                                  Spacer(),
                                  TextDecrease(store: store),
                                  TextIncrease(store: store),
                                  SizedBox(width: Constants().reactiveSize(
                                      10, 0, height, width),),
                                  FavoriteFAB(store: store, title: title)
                                ],
                              )
                            ],
                          ),
                        ),
                        color: Colors.transparent,
                      )) /*))*/,
                )),
            onTap: () {
              Navigator.pop(context);
            })));
  }
}
