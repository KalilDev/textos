import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:textos/Widgets/Widgets.dart';

// Implement optimization for the slideshow:
// Idea: Only load the Decoration image for the current ∓3 pages

class TextSlideshow extends StatefulWidget {
  createState() => TextSlideshowState();
}

class TextSlideshowState extends State<TextSlideshow> {
  List<Map<dynamic, dynamic>> _slideList;
  static Map<dynamic, dynamic> favoritesData;
  Stream _favoritesStream;

  @override
  void initState() {
    _favoritesStream = Firestore
        .instance
        .collection('favorites')
        .document('_stats_')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: <Widget>[
          ChangeNotifierProvider<QueryProvider>(
            builder: (_) => QueryProvider(),
            child: Consumer<QueryProvider>(
              builder: (context, provider, _) =>
                  StreamBuilder(
                      stream: provider.dataStream,
                      initialData: [],
                      builder: (context, AsyncSnapshot snap) {
                        final data = snap.data.toList();
                        _slideList = data.length == 0
                            ? [
                          Constants.textNoTextAvailable,
                        ]
                            : data;

                        StreamTransformer favsTransformer = new StreamTransformer
                            .fromHandlers(handleData: Provider
                            .of<FavoritesProvider>(context)
                            .streamTransformer);

                        return StreamBuilder(
                          stream: _favoritesStream.transform(favsTransformer),
                          builder: (context, AsyncSnapshot favoritesSnap) {
                            if (favoritesSnap.hasData) {
                              favoritesData = favoritesSnap.data;
                              favoritesData.forEach((textPath, favoriteInt) {
                                int targetIndex = _slideList.indexWhere((
                                    element) =>
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
                                child: StoryPages(slideList: _slideList)
                            );
                          },
                        );
                      }),
            ),
          ),
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
}
