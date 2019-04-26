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
            : Constants.themeDataLight,
        home: new Scaffold(
            drawer: TextAppDrawer(store: store),
            body: Stack(
              children: <Widget>[
                GestureDetector(
                    child: Hero(
                        tag: map['title'],
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 50, bottom: 20, right: 20, left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme
                                  .of(context)
                                  .backgroundColor,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(img),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme
                                        .of(context)
                                        .primaryColor
                                        .withAlpha(125),
                                    blurRadius: blur,
                                    offset: Offset(offset, offset))
                              ]),
                          child: Material(
                              color: Colors.transparent,
                              child: BlurOverlay(
                                enabled: BlurSettings(store).getTextsBlur(),
                                radius: 20,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20)),
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20.0),
                                            child: SingleChildScrollView(
                                              child:
                                              Column(children: <Widget>[
                                                Text(title,
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: Constants()
                                                        .textstyleTitle(
                                                        store.state
                                                            .textSize)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(text,
                                                    style: Constants()
                                                        .textstyleText(
                                                        store.state
                                                            .textSize)),
                                                SizedBox(
                                                  height: 55,
                                                  child: Center(
                                                    child: Text(date,
                                                        style: Constants()
                                                            .textstyleDate(
                                                            store.state
                                                                .textSize)),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              )),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                Positioned(child: new DrawerButton(), top: 5, left: 5,),
                Positioned(
                  child: FavoriteFAB(store: store, title: title),
                  right: 30,
                  bottom: 30,
                ),
                Positioned(
                  child: BlurOverlay(
                    enabled: BlurSettings(store).getButtonsBlur(),
                    radius: 80,
                    child: Material(
                      color: Theme
                          .of(context)
                          .accentColor
                          .withAlpha(150),
                      child: Row(children: <Widget>[
                        TextDecrease(store: store),
                        TextIncrease(store: store),
                      ]),
                    ),
                  ),
                  left: 20,
                  bottom: 33.5,
                ),
              ],
            )));
  }
}
