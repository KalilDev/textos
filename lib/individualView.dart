import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:textos/constants.dart';
import 'package:textos/favorites.dart';

class TextCard extends StatefulWidget {
  // Declare a field that holds the Todo
  final Map map;
  final int index;

  // In the constructor, require a Todo
  TextCard({Key key, @required this.map, this.index}) : super(key: key);

  createState() => TextCardState(map: map, index: index);
}

class TextCardState extends State<TextCard> {
  // Declare a field that holds the data map, and a field that holds the index
  final Map map;
  final int index;

  // In the constructor, require the data map and index
  TextCardState({Key key, @required this.map, this.index});

  @override
  Widget build(BuildContext context) {
    // Sanitize input
    final title = map['title'] ?? Constants.placeholderTitle;
    final text = map['text'] ?? Constants.placeholderText;
    final date = map['date'] ?? Constants.placeholderDate;
    final img = map['img'] ?? Constants.placeholderImg;

    final double blur = 30;
    final double offset = 10;

    final favorite = Favorites().isFavorite(title);
    return MaterialApp(
        theme: Constants.themeData, home: new Scaffold(
        drawer: FavoritesDrawer(),
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
                      color: Constants.themeBackground.withAlpha(115)),
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
                                            .textstyleTitle()),
                                    SizedBox(height: 10,),
                                    Text(text,
                                        style: Constants().textstyleText()),
                                  ],
                                ),
                              )),
                          Row(
                            children: <Widget>[
                              Text(date,
                                  style: Constants().textstyleDate()),
                              Spacer(),
                              FloatingActionButton(
                                  child: Icon(
                                    Icons.favorite,
                                    color: favorite ? Colors.red : Constants
                                        .themeBackground,
                                  ),
                                  backgroundColor:
                                  favorite
                                      ? Constants.themeBackground
                                      : Constants.themeAccent,
                                  onPressed: () {
                                    setState(() {
                                      Favorites().setFavorite(title);
                                    });
                                  })
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
