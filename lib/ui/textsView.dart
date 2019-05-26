import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView.dart';
import 'package:textos/ui/favoritesCount.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class TextsView extends StatefulWidget {
  @override
  _TextsViewState createState() => _TextsViewState();
}

class _TextsViewState extends State<TextsView> {
  IndexController _indexController;
  Stream _favoritesStream;
  Query _query;
  static Map<dynamic, dynamic> favoritesData;
  Firestore _db = Firestore.instance;
  List _slideList;

  Stream get slidesStream =>
      _query.snapshots().map((list) =>
          list.documents.map((doc) {
            final Map data = doc.data;
            data['path'] = doc.reference.path;
            data['favoriteCount'] = 0;
            return data;
          }));

  void updateQuery() {
    final queryInfo = Provider.of<QueryInfoProvider>(context);
    if (queryInfo.tag != Constants.textAllTag) {
      _query =
          _db.collection(queryInfo.collection).where(
              'tags', arrayContains: queryInfo.tag).orderBy(
              'date', descending: true);
    } else {
      _query = _db.collection(queryInfo.collection).orderBy(
          'date', descending: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _favoritesStream = _db
        .collection('favorites')
        .document('_stats_')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.data);
    _indexController = new IndexController();
  }

  @override
  Widget build(BuildContext context) {
    updateQuery();
    return StreamBuilder(
        stream: slidesStream,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          final data = snap.data.toList();
          _slideList = data.length == 0
              ? [
            Constants.textNoTextAvailable,
          ]
              : data;
          return StreamBuilder(
            stream: _favoritesStream,
            builder: (context, AsyncSnapshot favoritesSnap) {
              if (favoritesSnap.hasData) {
                favoritesData = favoritesSnap.data;
                favoritesData.forEach((textPath, favoriteInt) {
                  int targetIndex = _slideList.indexWhere((element) =>
                  element['path'] ==
                      textPath.toString().replaceAll('_', '/'));
                  if (targetIndex >= 0)
                    _slideList.elementAt(
                        targetIndex)['favoriteCount'] =
                        favoriteInt;
                });
              }

              return ChangeNotifierProvider<TextPageProvider>(
                  builder: (_) => TextPageProvider(),
                  child: TransformerPageView(
                    pageSnapping: false,
                    controller: _indexController,
                    viewportFraction: 0.80,
                    curve: Curves.decelerate,
                    physics: BouncingScrollPhysics(),
                    transformer: new PageTransformerBuilder(
                        builder: (Widget child, TransformInfo info) {
                          final data = _slideList[info.index];
                          return _TextPage(
                              info: info,
                              textContent: Content.fromData(data),
                              indexController: _indexController);
                        }),
                    onPageChanged: (page) {
                      HapticFeedback.lightImpact();
                    },
                    itemCount: _slideList.length,
                  ));
            },
          );
        });
  }
}

class _TextPage extends StatelessWidget {
  final Content textContent;
  final TransformInfo info;
  final IndexController indexController;

  _TextPage(
      {@required this.info, @required this.textContent, this.indexController});

  @override
  Widget build(BuildContext context) {
    final bool active = info.position.round() == 0.0 && info.position >= -0.35;
    // Animated Properties
    final double blur = lerpDouble(30, 0, info.position.abs());
    final double offset = lerpDouble(20, 0, info.position.abs());
    final double top = MediaQuery
        .of(context)
        .padding
        .top + 60;

    final textTheme = Theme
        .of(context)
        .accentTextTheme;

    return GestureDetector(
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration: Constants.durationAnimationMedium,
              curve: Curves.decelerate,
              margin: EdgeInsets.only(
                  top: active ? top : 180, bottom: 20, right: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(80),
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              child: Hero(
                  tag: 'image' + textContent.textPath,
                  child: ImageBackground(
                      img: textContent.imgUrl,
                      enabled: false,
                      position: info.position,
                      key: Key('image' + textContent.textPath))),
            ),
            AnimatedContainer(
              duration: Constants.durationAnimationMedium,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(
                  top: active ? top : 180, bottom: 20, right: 30),
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
                          margin: EdgeInsets.all(12.5),
                          child: BlurOverlay.roundedRect(
                              radius: 15,
                              enabled:
                              Provider
                                  .of<BlurProvider>(context)
                                  .textsBlur,
                              child: ParallaxContainer(
                                translationFactor: 300,
                                position: info.position,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: Text(textContent.title,
                                      textAlign: TextAlign.center,
                                      style: textTheme.display1),
                                ),
                              )),
                        ),
                        color: Colors.transparent,
                      ),
                    )),
              ),
            ),
            AnimatedSwitcher(
                duration: Constants.durationAnimationShort,
                switchInCurve: Curves.decelerate,
                switchOutCurve: Curves.decelerate,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                  alignment: FractionalOffset.bottomCenter,
                ),
                child: info.position.round() == 0.0
                    ? Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: FavoritesCount(
                        favorites: textContent.favoriteCount,
                        text:
                        textContent.title + ';' + textContent.textPath,
                        blurEnabled:
                        Provider
                            .of<BlurProvider>(context)
                            .buttonsBlur))
                    : SizedBox())
          ],
        ),
        onTap: () async {
          HapticFeedback.selectionClick();
          if (indexController != null) indexController.move(info.index);
          final result = await Navigator.push(
              context,
              FadeRoute(
                  builder: (context) =>
                      CardView(
                        blurProvider: Provider.of<BlurProvider>(context),
                        darkModeProvider: Provider.of<ThemeProvider>(context),
                        textSizeProvider:
                        Provider.of<TextSizeProvider>(context),
                        favoritesProvider:
                        Provider.of<FavoritesProvider>(context),
                        textContent: textContent,
                      )));
          List resultList = result;
          Provider.of<FavoritesProvider>(context).sync(resultList[0]);
          Provider.of<ThemeProvider>(context).sync(resultList[1]);
          Provider.of<BlurProvider>(context).sync(resultList[2]);
          Provider.of<TextSizeProvider>(context).sync(resultList[3]);
        });
  }
}
