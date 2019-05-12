import 'package:flutter/foundation.dart';

class DarkModeProvider with ChangeNotifier {
  bool _enabled;

  DarkModeProvider(bool enabled) {
    _enabled = enabled;
  }

  bool get isDarkMode => _enabled;

  toggle() {
    _enabled = !_enabled;
    notifyListeners();
  }

  reset() {
    _enabled = false;
    notifyListeners();
  }

  DarkModeProvider copy() => DarkModeProvider(_enabled);

  sync(bool isDarkMode) {
    _enabled = isDarkMode;
    notifyListeners();
  }
}
