import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/main.dart';

class TextSizeTap {
  final Store<AppStateMain> store;

  TextSizeTap({@required this.store});

  void increase() {
    if (store.state.textSize < 5.4) {
      store.dispatch(UpdateTextSize(size: store.state.textSize + 0.5));
    }
  }

  void decrease() {
    if (store.state.textSize > 2.1) {
      store.dispatch(UpdateTextSize(size: store.state.textSize - 0.5));
    }
  }
}
