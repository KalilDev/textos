import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextSizeProvider with ChangeNotifier {
  double _textSize;
  bool increased = false;
  bool decreased = false;

  TextSizeProvider(double textSize) {
    _textSize = textSize;
  }

  double get textSize => _textSize;

  increase() {
    _textSize = _textSize < 6.4 ? _textSize = _textSize + 0.5 : _textSize;
    increased = true;
    settingsSync();
    notifyListeners();
  }

  decrease() {
    _textSize = _textSize > 3.1 ? _textSize = _textSize - 0.5 : _textSize;
    decreased = true;
    settingsSync();
    notifyListeners();
  }

  reset() {
    _textSize = 4.5;
    settingsSync();
    notifyListeners();
  }

  TextSizeProvider copy() => TextSizeProvider(_textSize);
  sync(double textSize) {
    _textSize = textSize;
    notifyListeners();
  }

  settingsSync() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('textSize', _textSize);
  }
}
