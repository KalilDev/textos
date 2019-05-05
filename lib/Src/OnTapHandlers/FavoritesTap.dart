import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Views/FirestoreSlideshowView.dart';
import 'package:textos/main.dart';

class FavoritesTap {
  final Store<AppStateMain> store;
  final String text;

  FavoritesTap({@required this.store, @required this.text});

  void onTap() {
    bool favorite = store.state.favoritesSet.any((string) => string == text);
    if (text.split(';')[1].split('/')[1] !=
        Constants.textNoTextAvailable['id']) {
      final idx = TextSlideshowState.slideList.indexWhere((map) {
        return map['id'] == text.split(';')[1].split('/')[1];
      });
      if (favorite) {
        final int current = TextSlideshowState.slideList[idx]['favorites'] ?? 1;
        TextSlideshowState.slideList[idx]['favorites'] =
            current == 0 ? 0 : current - 1;
        store.dispatch(UpdateFavorites(toRemove: text));
      } else {
        final int current = TextSlideshowState.slideList[idx]['favorites'] ?? 0;
        TextSlideshowState.slideList[idx]['favorites'] =
            current == -1 ? 1 : current + 1;
        store.dispatch(UpdateFavorites(toAdd: text));
      }
    }
  }
}
