import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'individualView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new Scaffold(
            //drawer: Drawer(
            //  child: Container(
            //    color: Colors.lightBlueAccent,
            //  ),
            //),
            body: FirestoreSlideshow()));
  }
}

class FirestoreSlideshow extends StatefulWidget {
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<FirestoreSlideshow> {
  Stream _queryDb({String tag = 'Todos'}) {
    // Make a Query
    Query query;
    if (tag == 'Todos') {
      print(tag);
      query = db.collection('stories');
    } else {
      query = db.collection('stories').where('tags', arrayContains: tag);
    }

    // Map the documents to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }

  final PageController ctrl = PageController(viewportFraction: 0.8);

  final Firestore db = Firestore.instance;
  Stream slides;

  String activeTag = 'Todos';

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  @override
  void initState() {
    _queryDb();

    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  // Builder Functions

  _buildStoryPage(Map data, bool active, int index) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    ImageProvider img;

    if (data['img'].contains('http')) {
      img = CachedNetworkImageProvider(data['img']);
    } else {
      img = CachedNetworkImageProvider(
          'https://i.pinimg.com/originals/9d/66/da/9d66da266df9f8f8edbc14db92efbe30.jpg');
    }

    return GestureDetector(
        child: Hero(
            tag: data['title'],
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
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
              child: Center(
                  child: Material(
                child: Text(data['title'],
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Merriweather')),
                color: Colors.transparent,
              )),
            )),
        onTap: () {
          if (!active) {
            ctrl.animateToPage(index,
                duration: Duration(milliseconds: 100),
                curve: Curves.decelerate);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new IndividualView(map: data)),
            );
          }
        });
  }

  Widget _buildButton(tag) {
    Color color = tag == activeTag ? Colors.lightBlueAccent : Colors.white;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () => _queryDb(tag: tag));
  }

  _buildTagPage() {
    var texto = 'do Kalil';
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'Textos ',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Merriweather'),
            ),
            GestureDetector(
              child: Container(
                constraints: BoxConstraints.expand(height: 45.0, width: 200.0),
                child: Text(
                  '$texto',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Merriweather'),
                ),
              ),
              onTap: () {
                //TODO
              },
            ),
          ],
        ),
        Text('FILTRO',
            style:
                TextStyle(color: Colors.black26, fontFamily: 'Merriweather')),
        _buildButton('Todos'),
        _buildButton('Crônicas'),
        _buildButton('Reflexões'),
        _buildButton('Desabafos')
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          List slideList = snap.data.toList();

          return PageView.builder(
              controller: ctrl,
              itemCount: slideList.length + 1,
              itemBuilder: (context, int currentIdx) {
                if (currentIdx == 0) {
                  return _buildTagPage();
                } else if (slideList.length >= currentIdx) {
                  // Active page
                  bool active = currentIdx == currentPage;
                  return _buildStoryPage(
                      slideList[currentIdx - 1], active, currentIdx);
                }
              });
        });
  }
}

/*
class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute(Map data, int index)
      : super(
            builder: (context) => new IndividualView(
                  map: data,
                  index: index
                ));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
      return ScaleTransition(scale: new Tween<double>(
        begin: 0.0,
        end: 1.0
        ).animate(CurvedAnimation(parent: animation, curve: Interval(
        1.0,
        0.8,
        curve: Curves.decelerate))), child: child);
  }
}*/
