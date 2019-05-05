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

  // Make a Query
  static Query query;

  void _queryDb({int tag = 0}) {
    query = db.collection(Constants.authorCollections[store.state.author]);

    if (tag != 0)
      query = query.where('tags', arrayContains: Constants.textTag[tag]);

    // Map the documents to the data payload
    slides = query.snapshots().map((list) =>
        list.documents.map((doc) {
          final Map data = doc.data;
          data['id'] = doc.documentID;
          return data;
        }));

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
        Vibration.vibrate(duration: 90);
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
    final favorites = data['favorites'] ?? 0;
    final text = data['title'] + ';' +
        Constants.authorCollections[store.state.author] +
        '/' + data['id'];

    onFavoriteToggle() {
      FavoritesTap(store: store).toggle(text);
    }

    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
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
              duration: Duration(milliseconds: 600),
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
            active ? Align(
                alignment: FractionalOffset.bottomCenter,
                child: FavoritesCount(
                    favorites: favorites,
                    isFavorite: store.state.favoritesSet.any((
                        favorite) => favorite == text),
                    text: text,
                    blurEnabled: BlurSettingsParser(
                        blurSettings: store.state.blurSettings).getTextsBlur(),
                    favoritesTap: onFavoriteToggle,
                    textSize: store.state.textSize)) : NullWidget()
          ],
        ),
        onTap: () async {
          ctrl.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
          Navigator.push(
              context,
              CustomRoute(
                  builder: (context) =>
                      TextCardView(data: data, store: store)));
        });
  }

  Widget _buildButton(int id) {
    Color color = id == activeTag ? Constants.themeAccent : Colors.transparent;
    return FlatButton(
        color: color,
        child: Text(
          '#' + Constants.textTag[id],
          style: Constants().textStyleButton(store.state.textSize),
        ),
        onPressed: () => _queryDb(tag: id));
  }

  _buildTagPage() {
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
                ClipRect(
                  child: DropdownButton(
                      value: store.state.author,
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                            value: 0,
                            child: Text(Constants.authorNames[0],
                                style: Constants().textstyleTitle(
                                    store.state.textSize))),
                        DropdownMenuItem(
                            value: 1,
                            child: Text(Constants.authorNames[1],
                                style: Constants().textstyleTitle(
                                    store.state.textSize))),
                      ],
                      onChanged: (val) async {
                        store.dispatch(UpdateAuthor(author: val));
                        _queryDb();
                      }),
                )
              ],
            ),
            Text(Constants.textFilter,
                style: Constants().textstyleFilter(
                    store.state.textSize, store.state.enableDarkMode)),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: StreamBuilder(
          stream: slides,
          initialData: [],
          builder: (context, AsyncSnapshot snap) {
            final data = snap.data.toList();
            slideList =
            data.length == 0 ? [Constants.textNoTextAvailable,] : data;

            return PageView.builder(
                controller: ctrl,
                itemCount: slideList.length + 1,
                pageSnapping: false,
                itemBuilder: (context, int currentIdx) {
                  if (currentIdx == 0) {
                    return _buildTagPage();
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
