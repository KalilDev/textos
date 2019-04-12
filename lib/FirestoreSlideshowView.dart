import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Constants.dart';
import 'package:textos/TextCardView.dart';
import 'package:textos/main.dart';


class TextSlideshow extends StatefulWidget {
  final Store store;

  TextSlideshow({@required this.store});

  createState() => TextSlideshowState(store: store);
}

class TextSlideshowState extends State<TextSlideshow> {
  final Store<AppStateMain> store;

  TextSlideshowState({@required this.store});

  // Make a Query
  static Query query;

  void _queryDb({int tag = 0}) {
    switch (tag) {
      case 0:
        {
          query = db.collection('stories');
        }
        break;

      default:
        {
          query = db
              .collection('stories')
              .where('tags', arrayContains: Constants.textTag[tag]);
        }
    }

    // Map the documents to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }

  static final PageController ctrl = PageController(viewportFraction: 0.85);

  final Firestore db = Firestore.instance;
  Stream slides;

  int activeTag = 0;

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
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

  _buildStoryPage(Map data, bool active, int index) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? Constants().reactiveSize(
        20, 1, height, width) : 0;
    final double top = active
        ? Constants().reactiveSize(60, 0, height, width)
        : Constants().reactiveSize(180, 0, height, width);

    final title = data['title'] ?? Constants.placeholderTitle;
    final img = data['img'] ?? Constants.placeholderImg;

    return GestureDetector(
        child: Hero(
            tag: title,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              margin: EdgeInsets.only(top: top,
                  bottom: Constants().reactiveSize(50, 0, height, width),
                  right: Constants().reactiveSize(30, 1, height, width)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constants.themeBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(img),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Constants.themeForeground.withAlpha(80),
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              child: Center(
                  child: Material(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constants.themeBackground.withAlpha(125)),
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: Constants().textstyleTitle(
                              store.state.textSize)),
                    ),
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
                  builder: (context) => new TextCard(map: data, store: store)),
            );
          }
        });
  }

  Widget _buildButton(int id) {
    Color color =
    id == activeTag ? Constants.themeAccent : Constants.themeBackground;
    return FlatButton(
        color: color,
        child: Text(
          '#' + Constants.textTag[id],
          style: Constants().textStyleButton(store.state.textSize),
        ),
        onPressed: () => _queryDb(tag: id));
  }

  _buildTagPage() {
    var texto = Constants.textKalil;
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Text(
                  Constants.textTextos,
                  style: Constants().textstyleTitle(store.state.textSize),
                ),
                Text(
                  texto,
                  style: Constants().textstyleTitle(store.state.textSize),
                ),
              ],
            ),
            Text(Constants.textFilter,
                style: Constants().textstyleFilter(store.state.textSize)),
            _buildButton(0),
            _buildButton(1),
            _buildButton(2),
            _buildButton(3)
          ],
        ));
  }

  static List slideList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          slideList = snap.data.toList();

          return PageView.builder(
              controller: ctrl,
              itemCount: slideList.length + 1,
              pageSnapping: false,
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