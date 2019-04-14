import 'package:cached_network_image/cached_network_image.dart';
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
    final themeBackground = Theme
        .of(context)
        .backgroundColor;
    final themeForeground = Theme
        .of(context)
        .primaryColor;

    // Sanitize input
    final title = map['title'] ?? Constants.placeholderTitle;
    final text = map['text'] ?? Constants.placeholderText;
    final date = map['date'] ?? Constants.placeholderDate;
    final img = map['img'] ?? Constants.placeholderImg;

    final double blur = 30;
    final double offset = 10;
    return MaterialApp(
        theme: store.state.enableDarkMode
            ? Constants.themeDataDark
            : Constants.themeDataLight, home: new Scaffold(
        drawer: TextAppDrawer(store: store),
        body: Stack(
          children: <Widget>[
            GestureDetector(
                child: Hero(
                    tag: map['title'],
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                          right: 20,
                          left: 10),
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
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: themeBackground.withAlpha(130)),
                            child:
                            /*new ClipRect(child: new BackdropFilter(
                        filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: */
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                        children: <Widget>[
                                          Text(title,
                                              textAlign: TextAlign.center,
                                              style: Constants()
                                                  .textstyleTitle(
                                                  store.state.textSize,
                                                  store.state.enableDarkMode)),
                                          SizedBox(
                                            height: 10,),
                                          Text(text,
                                              style: Constants().textstyleText(
                                                  store.state.textSize,
                                                  store.state.enableDarkMode)),
                                          SizedBox(
                                            height: 55,
                                            child: Center(
                                              child: Text(date,
                                                  style: Constants()
                                                      .textstyleDate(
                                                      store.state.textSize,
                                                      store.state
                                                          .enableDarkMode)),

                                            ),),
                                        ]),
                                  ),
                                ),
                              ],
                            )),
                      ) /*))*/,
                    )),
                onTap: () {
                  Navigator.pop(context);
                }),
            Positioned(child: FavoriteFAB(store: store, title: title),
              right: 30,
              bottom: 30,
            ),
            Positioned(child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: Theme
                      .of(context)
                      .accentColor
              ),
              child: Material(color: Colors.transparent,
                child: Container(
                  child: Row(
                      children: <Widget>[
                        TextDecrease(store: store, isBackground: true),
                        TextIncrease(store: store, isBackground: true),
                      ]),
                ),
              ),
            ),
              left: 20,
              bottom: 33.5,
            ),
          ],
        )));
  }
}
