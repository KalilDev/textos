import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Views/FirestoreSlideshowView.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/main.dart';

class FavoritesTap {
  final Store<AppStateMain> store;

  FavoritesTap({@required this.store});

  final slideList = TextSlideshowState.slideList;

  String _getId(String text) {
    return text.split(';')[1].split('/')[1];
  }

  int _getIndexOnSlides(String text) {
    return TextSlideshowState.slideList.indexWhere((map) {
      return map['id'] == _getId(text);
    });
  }

  void toggle(String text) {
    bool favorite = store.state.favoritesSet.any((string) => string == text);
    if (_getId(text) !=
        Constants.textNoTextAvailable['id']) {
      final index = _getIndexOnSlides(text);
      if (favorite) {
        final int current = TextSlideshowState.slideList[index]['favorites'] ??
            1;
        TextSlideshowState.slideList[index]['favorites'] =
            current == 0 ? 0 : current - 1;
        store.dispatch(UpdateFavorites(toRemove: text));
      } else {
        final int current = TextSlideshowState.slideList[index]['favorites'] ??
            0;
        TextSlideshowState.slideList[index]['favorites'] =
            current == -1 ? 1 : current + 1;
        store.dispatch(UpdateFavorites(toAdd: text));
      }
    }
  }

  void remove(String text) {
    store.dispatch(UpdateFavorites(toRemove: text));
  }

  void open(String text, BuildContext context) {
    final index = _getIndexOnSlides(text);
    if (index != -1) {
      TextSlideshowState.ctrl.jumpToPage(index + 1);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TextCardView(data: slideList[index], store: store)),
      );
    }
  }
}
