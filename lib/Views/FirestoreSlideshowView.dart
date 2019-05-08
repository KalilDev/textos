import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/OnTapHandlers/FavoritesTap.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';
import 'package:vibration/vibration.dart';

// Implement optimization for the slideshow:
// Idea: Only load the Decoration image for the current ∓3 pages

class TextSlideshow extends StatefulWidget {
  final Store store;

  TextSlideshow({@required this.store});

  createState() => TextSlideshowState(store: store);
}

class TextSlideshowState extends State<TextSlideshow> {
  final Store<AppStateMain> store;

  TextSlideshowState({@required this.store});

  static Query metadataQuery;
  String authorCollection = 'stories';
  
  // Make a Query
  static Query query;

  void _queryDb({int tag = 0}) {
    query = db.collection(authorCollection);

    //if (tag != 0)
    //  query = query.where('tags', arrayContains: Constants.textTag[tag]);

    // Map the documents to the data payload
    slides = query.snapshots().map((list) =>
        list.documents.map((doc) {
          final Map data = doc.data;
          data['id'] = doc.documentID;
          data['localFavorites'] = 0;
          return data;
        }));
  }

  static final PageController ctrl = PageController(viewportFraction: 0.85);

  final Firestore db = Firestore.instance;
  Stream slides;

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
        Vibration.vibrate(duration: 60);
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  _buildStoryPage(Map data, int index) {
    // Active page
    bool active = index == currentPage;
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? MediaQuery
        .of(context)
        .padding
        .top + 10 : 180;

    final title = data['title'] ?? Constants.placeholderTitle;
    final img = data['img'] ?? Constants.placeholderImg;
    final String text = data['title'] +
        ';' +
        Constants.authorCollections[store.state.author] +
        '/' +
        data['id'];

    onFavoriteToggle() {
      FavoritesTap(store: store).toggle(text);
    }

    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Constants.durationAnimationMedium,
              curve: Curves.decelerate,
              margin: EdgeInsets.only(top: top, bottom: 20, right: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme
                      .of(context)
                      .backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme
                            .of(context)
                            .primaryColor
                            .withAlpha(80),
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              child: Hero(
                  tag: 'image' + data['id'],
                  child: ImageBackground(
                      img: img,
                      enabled: false,
                      key: Key('image' + data['id']))),
            ),
            AnimatedContainer(
              duration: Constants.durationAnimationLong,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: top, bottom: 20, right: 30),
              child: Center(
                  child: Hero(
                    tag: 'body' + data['id'],
                    child: Material(
                      child: Container(
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.all(12.5),
                        child: BlurOverlay(
                          radius: 15,
                          enabled: BlurSettingsParser(
                              blurSettings: store.state.blurSettings)
                              .getTextsBlur(),
                          child: Text(title,
                              textAlign: TextAlign.center,
                              style:
                              Constants().textstyleTitle(store.state.textSize)),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  )),
            ),
            FutureBuilder(
                future:
                db.document('favorites/_stats_').get().then((docSnapshot) {
                  final String textPath =
                  text.split(';')[1].replaceAll('/', '_');
                  final Map<String, dynamic> map =
                      docSnapshot?.data ?? {textPath: 0};
                  final favoriteCount = map[textPath] ?? 0;
                  return favoriteCount;
                }),
                initialData: 0,
                builder: (context, snapshot) {
                  return AnimatedSwitcher(
                      duration: Constants.durationAnimationShort,
                      switchInCurve: Curves.decelerate,
                      switchOutCurve: Curves.decelerate,
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(
                            scale: animation,
                            child: child,
                            alignment: FractionalOffset.bottomCenter,
                          ),
                      child: active
                          ? Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: FavoritesCount(
                              favorites: snapshot.data,
                              isFavorite: store.state.favoritesSet
                                  .any((favorite) => favorite == text),
                              text: text,
                              blurEnabled: BlurSettingsParser(
                                  blurSettings:
                                  store.state.blurSettings)
                                  .getTextsBlur(),
                              favoritesTap: onFavoriteToggle,
                              textSize: store.state.textSize))
                          : NullWidget());
                })
          ],
        ),
        onTap: () async {
          ctrl.animateToPage(index,
              duration: Constants.durationAnimationMedium,
              curve: Curves.decelerate);
          Navigator.push(
              context,
              CustomRoute(
                  builder: (context) =>
                      TextCardView(data: data, store: store)));
        });
  }

  _buildTagPages() {
    metadataQuery = db.collection('metadata').orderBy('order');
    Stream tagStream = metadataQuery.snapshots().map((list) =>
        list.documents.map((doc) => doc.data));
    return StreamBuilder(
      stream: tagStream,
      initialData: [{'title': 'Textos do ',
        'authorName': 'Kalil',
        'tags': ['Todos']}
      ],
      builder: (context, snapshot) {
        List<Map<dynamic, dynamic>> metadatas = snapshot.data.toList();
        return PageView.builder(
            onPageChanged: (index) {
              authorCollection = metadatas[index]['collection'];
              _queryDb();
            },
            itemCount: metadatas.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) =>
                TagPage(data: metadatas[index],
                    enableDarkMode: store.state.enableDarkMode,
                    textSize: store.state.textSize)
        );
      },
    );
  }

  static List slideList;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: StreamBuilder(
          stream: slides,
          initialData: [],
          builder: (context, AsyncSnapshot snap) {
            final data = snap.data.toList();
            slideList = data.length == 0
                ? [
              Constants.textNoTextAvailable,
            ]
                : data;

            return PageView.builder(
                controller: ctrl,
                itemCount: slideList.length + 1,
                pageSnapping: false,
                itemBuilder: (context, int currentIdx) {
                  if (currentIdx == 0) {
                    return _buildTagPages();
                  } else if (slideList.length >= currentIdx) {
                    return _buildStoryPage(
                        slideList[currentIdx - 1], currentIdx);
                  }
                });
          }),
    );
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
          opacity: Tween(begin: 0.0, end: 0.2).animate(animation),
          child: child);
    }
    return FadeTransition(opacity: animation, child: child);
  }
}
