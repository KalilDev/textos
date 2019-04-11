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
    // Sanitize input
    final title = map['title'] ?? Constants.placeholderTitle;
    final text = map['text'] ?? Constants.placeholderText;
    final date = map['date'] ?? Constants.placeholderDate;
    final img = map['img'] ?? Constants.placeholderImg;

    final double blur = 30;
    final double offset = 10;

    return MaterialApp(
        theme: Constants.themeData, home: new Scaffold(
        drawer: TextAppDrawer(store: store),
        body: GestureDetector(
        child: Hero(
            tag: map['title'],
            child: Container(
              margin: EdgeInsets.only(top: 40, bottom: 50, right: 30, left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constants.themeForeground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(img),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Constants.themeForeground.withAlpha(125),
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constants.themeBackground.withAlpha(130)),
                  child:
                  /*new ClipRect(child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: */
                  Material(
                    child: Container(
                      margin: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
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
                                            store.state.textSize)),
                                    SizedBox(height: 10,),
                                    Text(text,
                                        style: Constants().textstyleText(
                                            store.state.textSize)),
                                  ],
                                ),
                              )),
                          Row(
                            children: <Widget>[
                              Text(date,
                                  style: Constants().textstyleDate(
                                      store.state.textSize)),
                              Spacer(),
                              DrawerSettings(store: store).textButtons(1),
                              DrawerSettings(store: store).textButtons(0),
                              SizedBox(width: 10,),
                              DrawerSettings(store: store).favoriteFAB(title),
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
