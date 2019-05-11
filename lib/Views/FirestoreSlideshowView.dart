import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Providers/Providers.dart';
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

  List<Map<dynamic, dynamic>> _slideList;
  static Map<dynamic, dynamic> favoritesData;

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

                        Stream _favoritesStream = Firestore
                            .instance
                            .collection('favorites')
                            .document('_stats_')
                            .snapshots()
                            .map((documentSnapshot) => documentSnapshot.data);

                        return StreamBuilder(
                          stream: _favoritesStream,
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
