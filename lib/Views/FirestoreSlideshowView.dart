import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Controllers/QueryController.dart';
import 'package:textos/Src/Controllers/TagPageController.dart';
import 'package:textos/Src/Controllers/TextPageController.dart';
import 'package:textos/Src/OnTapHandlers/FavoritesTap.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

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

  static TextPageController textPageController;
  static TagPageController tagPageController;
  static QueryController queryController;

  @override
  void initState() {
    super.initState();
    tagPageController = new TagPageController();
    textPageController = new TextPageController();
    textPageController.addListener(() => setState(() {}), tagPageController);
    queryController = new QueryController(tagPageController: tagPageController);
  }

  _buildStoryPage(Map data, int index) {
    // Animated Properties
    final double blur = textPageController.isCurrent(index) ? 30 : 0;
    final double offset = textPageController.isCurrent(index) ? 20 : 0;
    final double top = textPageController.isCurrent(index)
        ? MediaQuery
        .of(context)
        .padding
        .top + 60
        : 180;

    final title = data['title'] ?? Constants.placeholderTitle;
    final img = data['img'] ?? Constants.placeholderImg;
    final String text = data['title'] +
        ';' +
        data['path'];

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
                  tag: 'image' + data['path'],
                  child: ImageBackground(
                      img: img,
                      enabled: false,
                      key: Key('image' + data['path']))),
            ),
            AnimatedContainer(
              duration: Constants.durationAnimationLong,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: top, bottom: 20, right: 30),
              child: Center(
                  child: Hero(
                    tag: 'body' + data['path'],
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
            AnimatedSwitcher(
                duration: Constants.durationAnimationShort,
                switchInCurve: Curves.decelerate,
                switchOutCurve: Curves.decelerate,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(
                      scale: animation,
                      child: child,
                      alignment: FractionalOffset.bottomCenter,
                    ),
                child: textPageController.isCurrent(index)
                    ? Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: FavoritesCount(
                        favorites: data['favoriteCount'],
                        isFavorite: store.state.favoritesSet
                            .any((favorite) => favorite == text),
                        text: text,
                        blurEnabled: BlurSettingsParser(
                            blurSettings: store.state.blurSettings)
                            .getTextsBlur(),
                        favoritesTap: onFavoriteToggle,
                        textSize: store.state.textSize))
                    : NullWidget())
          ],
        ),
        onTap: () async {
          textPageController.pageController.animateToPage(index,
              duration: Constants.durationAnimationMedium,
              curve: Curves.decelerate);
          Navigator.push(
              context,
              FadeRoute(
                  builder: (context) =>
                      TextCardView(data: data, store: store)));
        });
  }

  static Query metadataQuery;
  _buildTagPages() {
    metadataQuery = Firestore.instance.collection('metadata').orderBy('order');
    Stream tagStream = metadataQuery
        .snapshots()
        .map((list) => list.documents.map((doc) => doc.data));
    return StreamBuilder(
      stream: tagStream,
      initialData: [
        Constants.placeholderTagMetadata
      ],
      builder: (context, snapshot) {
        List metadatas = snapshot.data.toList();
        tagPageController.metadatas = metadatas;
        tagPageController.addListener(() => setState(() {}), queryController);
        return PageView.builder(
            controller: tagPageController.pageController,
            itemCount: metadatas.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) =>
                TagPage(
                    queryController: queryController,
                    tagPageController: tagPageController,
                    index: index,
                    enableDarkMode: store.state.enableDarkMode,
                    textSize: store.state.textSize));
      },
    );
  }

  List<Map<dynamic, dynamic>> _slideList;
  static Map<dynamic, dynamic> favoritesData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: queryController.dataStream,
              initialData: [],
              builder: (context, AsyncSnapshot snap) {
                final data = snap.data.toList();
                _slideList = data.length == 0
                    ? [
                  Constants.textNoTextAvailable,
                ]
                    : data;

                return StreamBuilder(
                  stream: queryController.favoritesStream,
                  builder: (context, AsyncSnapshot favoritesSnap) {
                    if (favoritesSnap.hasData) {
                      print(favoritesSnap.data);
                      favoritesData = favoritesSnap.data;
                      favoritesData.forEach((textPath, favoriteInt) {
                        int targetIndex = _slideList
                            .indexWhere((element) =>
                        element['path'] ==
                            textPath.toString().replaceAll('_', '/'));
                        if (targetIndex >= 0)
                          _slideList.elementAt(targetIndex)['favoriteCount'] =
                              favoriteInt;
                      });
                    }

                    return PageView.builder(
                        controller: textPageController.pageController,
                        itemCount: _slideList.length + 1,
                        pageSnapping: false,
                        itemBuilder: (context, int currentIdx) {
                          if (currentIdx == 0) {
                            return _buildTagPages();
                          } else if (_slideList.length >= currentIdx) {
                            return _buildStoryPage(
                                _slideList[currentIdx - 1], currentIdx);
                          }
                        });
                  },
                );
              }),
          Positioned(
            child: MenuButton(),
            top: MediaQuery
                .of(context)
                .padding
                .top - 2.5,
            left: -2.5,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textPageController.dispose();
    tagPageController.dispose();
    super.dispose();
  }
}
