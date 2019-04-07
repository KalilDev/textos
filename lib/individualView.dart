import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:textos/favorites.dart';

class IndividualView extends StatelessWidget {
  // Declare a field that holds the Todo
  final Map map;
  final int index;

  // In the constructor, require a Todo
  IndividualView({Key key, @required this.map, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new Scaffold(body: TextCard(map: map, index: index)));
  }
}

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
    final title = map['title'] ?? 'Titulo';
    final text = map['text'] ?? 'Texto';
    final date = map['date'] ?? '01/01/1970';
    final img = map['img'] ?? 'https://i.imgur.com/H6i4c32.jpg';

    final double blur = 30;
    final double offset = 10;

    final favorite = Favorites().isFavorite(title);
    return MaterialApp(home: new Scaffold(body: GestureDetector(
        child: Hero(
            tag: map['title'],
            child: Container(
              margin: EdgeInsets.only(top: 40, bottom: 50, right: 30, left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(img),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black87,
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0x71000000)),
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
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                20),
                                            color: Colors.black.withAlpha(70)),
                                        child: Text(' ' + title,
                                            style: TextStyle(
                                                fontSize: 45,
                                                color: Colors.white,
                                                fontFamily: 'Merriweather'))),
                                    SizedBox(height: 15,),
                                    Text(text,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'Muli')),
                                  ],
                                ),
                              )),
                          Row(
                            children: <Widget>[
                              Text(date,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontFamily: 'Merriweather')),
                              Spacer(),
                              FloatingActionButton(
                                  child: Icon(
                                    Icons.favorite,
                                    color: favorite ? Colors.red : Colors.white,
                                  ),
                                  backgroundColor:
                                  favorite ? Colors.white : Colors.blue,
                                  onPressed: () {
                                    setState(() {
                                      print(
                                          Favorites().list.toString() + '   ' +
                                              title);
                                      Favorites().setFavorite(title);
                                      print(Favorites().list);
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
