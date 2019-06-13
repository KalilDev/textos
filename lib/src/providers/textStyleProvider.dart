import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextStyleProvider with ChangeNotifier {
  TextStyleProvider(double textSize, int textAlign) {
    _textSize = textSize;
    _textAlign = textAlign;
  }

  double _textSize;
  int _textAlign;
  double get textSize => _textSize;
  TextAlign get textAlign => TextAlign.values.elementAt(_textAlign);

  set textAlign(TextAlign align) {
    _textAlign = align.index;
    settingsSync();
    notifyListeners();
  }

  void increase() {
    _textSize = _textSize < 6.4 ? _textSize = _textSize + 0.5 : _textSize;
    settingsSync();
    notifyListeners();
  }

  void decrease() {
    _textSize = _textSize > 3.1 ? _textSize = _textSize - 0.5 : _textSize;
    settingsSync();
    notifyListeners();
  }

  void reset() {
    _textSize = 4.5;
    settingsSync();
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('textSize', _textSize);
    prefs.setInt('textAlign', _textAlign);
  }
}
