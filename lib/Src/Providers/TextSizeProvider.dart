import 'package:flutter/foundation.dart';

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
    notifyListeners();
  }

  decrease() {
    _textSize = _textSize > 3.1 ? _textSize = _textSize - 0.5 : _textSize;
    decreased = true;
    notifyListeners();
  }

  reset() {
    _textSize = 4.5;
    notifyListeners();
  }

  TextSizeProvider copy() => TextSizeProvider(_textSize);
}
