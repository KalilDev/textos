import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/favorites.dart';

import 'constants.dart';
import 'individualView.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("isDark") == true) {
    Constants().setDarkTheme();
  } else {
    Constants().setWhiteTheme();
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldApp();
  }
}

class ScaffoldApp extends StatefulWidget {
  createState() => ScaffoldAppState();
}

class ScaffoldAppState extends State<ScaffoldApp> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        drawer: FavoritesDrawer(),
        body: FirestoreSlideshow(notifyParent: refresh),
      ),
      theme: Constants.themeData,);
  }
}
class FirestoreSlideshow extends StatefulWidget {
  final Function() notifyParent;

  FirestoreSlideshow({Key key, @required this.notifyParent}) : super(key: key);

  createState() => FirestoreSlideshowState(notifyParent: notifyParent);
}

class FirestoreSlideshowState extends State<FirestoreSlideshow> {
  final Function() notifyParent;

  FirestoreSlideshowState({Key key, @required this.notifyParent});

  static final Set<String> favorites = new Set<String>();
  static final Map<String, int> all = {};

  // Make a Query
  static Query query;

  Stream _queryDb({int tag = 0}) {
    FirestoreSlideshowState.all.clear();
    switch (tag) {
      case 0:
        {
          query = db.collection('stories');
        }
        break;

      default:
        {
          query = db.collection('stories').where(
              'tags', arrayContains: Constants.textTag[tag]);
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

  static final PageController ctrl = PageController(viewportFraction: 0.8);

  final Firestore db = Firestore.instance;
  Stream slides;

  int activeTag = 0;

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

  _buildStoryPage(Map data, bool active, int index) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    FirestoreSlideshowState.all[data['title']] = index;

    final title = data['title'] ?? Constants.placeholderTitle;
    final img = data['img'] ?? Constants.placeholderImg;

    return GestureDetector(
        child: Hero(
            tag: title,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
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
                          borderRadius: BorderRadius.circular(
                              20),
                          color: Constants.themeBackground.withAlpha(125)),
                      child: Text(title, textAlign: TextAlign.center,
                          style: Constants().textstyleTitle()),
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
                  builder: (context) => new TextCard(map: data)),
            );
          }
        });
  }

  Widget _buildButton(int id) {
    Color color = id == activeTag ? Constants.themeAccent : Constants
        .themeBackground;
    return FlatButton(
        color: color,
        child: Text('#' + Constants.textTag[id],
          style: TextStyle(color: Constants.themeForeground),),
        onPressed: () => _queryDb(tag: id));
  }

  Widget _buildThemeButton() {
    Color color = Constants.themeForeground;
    return FlatButton(
        color: color,
        child: Text(Constants.textTema,
          style: TextStyle(color: Constants.themeBackground),),
        onPressed: () {
          setState(() {
            Constants().changeTheme();
          });
          notifyParent();
          SharedPreferences.getInstance().then((pref) {
            var isDark = pref?.getBool('isDark') ?? false;
            pref.setBool('isDark', !isDark);
          });
        }
    );
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
                  style: Constants().textstyleTitle(),
                ),
                GestureDetector(
                  child: Container(
                    constraints: BoxConstraints.expand(height: 45.0, width: 200.0),
                    child: Text(
                      texto,
                      style: Constants().textstyleTitle(),
                    ),
                  ),
                  onTap: () {
                    //TODO
                  },
                ),
              ],
            ),
            Text(Constants.textFilter,
                style: Constants().textstyleFilter()),
            _buildButton(0),
            _buildButton(1),
            _buildButton(2),
            _buildButton(3),
            _buildThemeButton()
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
