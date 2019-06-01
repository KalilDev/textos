import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/mixins.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class TextsView extends StatefulWidget {
  @override
  _TextsViewState createState() => _TextsViewState();
}

class _TextsViewState extends State<TextsView> with Haptic {
  IndexController _indexController;
  Stream<Map<String, dynamic>> _favoritesStream;
  Query _query;
  static Map<String, dynamic> favoritesData;
  final Firestore _db = Firestore.instance;
  List<Map<String, dynamic>> _slideList;

  Stream<Iterable<Map<String, dynamic>>> get slidesStream => _query
      .snapshots()
      .map<Iterable<Map<String, dynamic>>>((QuerySnapshot list) =>
          list.documents.map<Map<String, dynamic>>((DocumentSnapshot doc) {
            final Map<String, dynamic> data = doc.data;
            data['path'] = doc.reference.path;
            data['favoriteCount'] = 0;
            return data;
          }));

  void updateQuery() {
    final QueryInfoProvider queryInfo = Provider.of<QueryInfoProvider>(context);
    if (queryInfo.tag != textAllTag) {
      _query = _db
          .collection(queryInfo.collection)
          .where('tags', arrayContains: queryInfo.tag)
          .orderBy('date', descending: true);
    } else {
      _query = _db
          .collection(queryInfo.collection)
          .orderBy('date', descending: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _favoritesStream = _db
        .collection('favorites')
        .document('_stats_')
        .snapshots()
        .map((DocumentSnapshot documentSnapshot) => documentSnapshot.data);
    _indexController = IndexController();
  }

  @override
  Widget build(BuildContext context) {
    updateQuery();
    return StreamBuilder<Iterable<Map<String, dynamic>>>(
        stream: slidesStream,
        builder: (BuildContext context,
            AsyncSnapshot<Iterable<Map<String, dynamic>>> snap) {
          return StreamBuilder<Map<String, dynamic>>(
            stream: _favoritesStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> favoritesSnap) {
              if (snap.hasData) {
                _slideList = snap.data.toList();
                if (favoritesSnap.hasData) {
                  favoritesData = favoritesSnap.data;
                  favoritesData.forEach((String textPath, dynamic favoriteInt) {
                    final int targetIndex = _slideList.indexWhere(
                        (Map<String, dynamic> element) =>
                            element['path'] ==
                            textPath.toString().replaceAll('_', '/'));
                    if (targetIndex >= 0)
                      _slideList.elementAt(targetIndex)['favoriteCount'] =
                          favoriteInt;
                  });
                }
              }

              return ChangeNotifierProvider<TextPageProvider>(
                  builder: (_) => TextPageProvider(),
                  child: TransformerPageView(
                    pageSnapping: false,
                    controller: _indexController,
                    viewportFraction: 0.80,
                    curve: Curves.decelerate,
                    transformer: PageTransformerBuilder(
                        builder: (Widget child, TransformInfo info) {
                      if (snap.hasData) {
                        final Map<String, dynamic> data =
                            _slideList[info.index];
                        return _TextPage(
                            info: info,
                            textContent: Content.fromData(data),
                            indexController: _indexController);
                      } else {
                        return Container(
                            child: Center(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const <Widget>[
                              Icon(Icons.error_outline, size: 72),
                              Text(
                                textNoTexts,
                                textAlign: TextAlign.center,
                              )
                            ])));
                      }
                    }),
                    onPageChanged: (int page) {
                      scrollFeedback();
                    },
                    itemCount: _slideList?.length ?? 1,
                  ));
            },
          );
        });
  }
}

class _TextPage extends StatelessWidget with Haptic {
  const _TextPage(
      {@required this.info, @required this.textContent, this.indexController});

  final Content textContent;
  final TransformInfo info;
  final IndexController indexController;

  @override
  Widget build(BuildContext context) {
    final bool active = info.position.round() == 0.0 && info.position >= -0.30;
    // Animated Properties
    final double elevation = active ? 16 : 0;
    const double vertical = 10;
    const double k = 80;

    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: durationAnimationMedium,
              curve: Curves.decelerate,
              margin: EdgeInsets.only(
                  top: active ? vertical : vertical + k,
                  bottom: vertical,
                  right: 30),
              child: ElevatedContainer(
                elevation: elevation,
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: <Widget>[
                    Hero(
                        tag: 'image' + textContent.textPath,
                        child: ImageBackground(
                            img: textContent.imgUrl,
                            enabled: false,
                            position: info.position,
                            key: Key('image' + textContent.textPath))),
                    RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Hero(
                              tag: 'body' + textContent.textPath,
                              child: Material(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: const EdgeInsets.all(8.0),
                                  child: BlurOverlay.roundedRect(
                                      radius: 15,
                                      enabled:
                                          Provider.of<BlurProvider>(context)
                                              .textsBlur,
                                      child: ParallaxContainer(
                                        translationFactor: 300,
                                        position: info.position,
                                        child: Text(textContent.title,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .accentTextTheme
                                                .display1),
                                      )),
                                ),
                                color: Colors.transparent,
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: AnimatedSwitcher(
                          duration: durationAnimationShort,
                          switchInCurve: Curves.decelerate,
                          switchOutCurve: Curves.decelerate,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  ScaleTransition(
                                    scale: animation,
                                    child: child,
                                    alignment: FractionalOffset.bottomCenter,
                                  ),
                          child: active
                              ? Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: ExpandedFABCounter(
                                      isEnabled:
                                          Provider.of<FavoritesProvider>(context)
                                              .isFavorite(textContent.title +
                                                  ';' +
                                                  textContent.textPath),
                                      onPressed: () =>
                                          Provider.of<FavoritesProvider>(context)
                                              .toggle(textContent.title +
                                                  ';' +
                                                  textContent.textPath),
                                      counter: textContent.favoriteCount,
                                      isBlurred:
                                          Provider.of<BlurProvider>(context)
                                              .buttonsBlur))
                              : const SizedBox()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () async {
          openView();
          if (indexController != null) indexController.move(info.index);
          Navigator.push(
              context,
              FadeRoute<void>(
                  builder: (BuildContext context) => CardView(
                        textContent: textContent,
                      )));
        });
  }
}
