import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/mixins.dart';

class TextSizeProvider with ChangeNotifier, Haptic {
  TextSizeProvider(double textSize) {
    _textSize = textSize;
  }

  double _textSize;

  double get textSize => _textSize;

  void increase() {
    selectItem();
    _textSize = _textSize < 6.4 ? _textSize = _textSize + 0.5 : _textSize;
    settingsSync();
    notifyListeners();
  }

  void decrease() {
    selectItem();
    _textSize = _textSize > 3.1 ? _textSize = _textSize - 0.5 : _textSize;
    settingsSync();
    notifyListeners();
  }

  void reset() {
    _textSize = 4.5;
    settingsSync();
    notifyListeners();
  }

  TextSizeProvider copy() => TextSizeProvider(_textSize);

  void sync(double textSize) {
    _textSize = textSize;
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('textSize', _textSize);
  }
}
