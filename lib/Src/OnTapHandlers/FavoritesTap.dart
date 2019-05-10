import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Views/FirestoreSlideshowView.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/Widgets/Widgets.dart';
import 'package:textos/main.dart';

class FavoritesTap {
  final Store<AppStateMain> store;

  FavoritesTap({@required this.store});

  String _getPath(String text) {
    return text.split(';')[1];
  }

  String _getKeyOnSlides(String text) {
    return _getPath(text).replaceAll('/', '_');
  }

  void toggle(String text) {
    bool favorite = store.state.favoritesSet.any((string) => string == text);
    if (_getPath(text) != Constants.textNoTextAvailable['path']) {
      int currentFavs = TextSlideshowState.favoritesData[_getKeyOnSlides(
          text)] ?? 0;
      if (favorite) {
        TextSlideshowState.favoritesData[_getKeyOnSlides(text)] =
            currentFavs - 1;
        store.dispatch(UpdateFavorites(toRemove: text));
      } else {
        TextSlideshowState.favoritesData[_getKeyOnSlides(text)] =
            currentFavs + 1;
        store.dispatch(UpdateFavorites(toAdd: text));
      }
    }
  }

  void remove(String text) {
    store.dispatch(UpdateFavorites(toRemove: text));
  }

  void open(String text, BuildContext context) async {
    final documentSnapshot = await Firestore.instance.document(_getPath(text))
        .get();
    var data = documentSnapshot.data;
    data['path'] = _getPath(text);
    Navigator.pop(context);
    Navigator.push(
      context,
      FadeRoute(
          builder: (context) =>
              TextCardView(data: documentSnapshot.data, store: store)),
    );
  }
}
