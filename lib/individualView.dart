import 'dart:convert';
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
  // Declare a field that holds the Todo
  final Map map;
  final int index;

  // In the constructor, require a Todo
  TextCardState({Key key, @required this.map, this.index});

  @override
  Widget build(BuildContext context) {
    // Sanitize input
    var title;
    var text;
    var date;
    if (map['title'] == null) {
      title = 'Texto';
    } else {
      title = map['title'];
    }
    if (map['text'] == null) {
      text = 'PLACEHOLDER';
    } else {
      text = '  ' + map['text'];
    }
    if (map['date'] == null) {
      date = '01/01/1970';
    } else {
      date = map['date'];
    }
    final double blur = 30;
    final double offset = 10;

    ImageProvider img;
    if (map['img'].contains('http')) {
      img = CachedNetworkImageProvider(map['img']);
    } else if (map['img'].toString().length > 10) {
      img = MemoryImage(Base64Decoder().convert(map['img']));
    } else {
      img = CachedNetworkImageProvider(
          'https://i.pinimg.com/originals/9d/66/da/9d66da266df9f8f8edbc14db92efbe30.jpg');
    }

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
                    image: img,
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
