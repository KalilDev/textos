import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeProvider with ChangeNotifier {
  bool _enabled;

  DarkModeProvider(bool enabled) {
    _enabled = enabled;
  }

  bool get isDarkMode => _enabled;

  toggle() {
    _enabled = !_enabled;
    settingsSync();
    notifyListeners();
  }

  reset() {
    _enabled = false;
    settingsSync();
    notifyListeners();
  }

  DarkModeProvider copy() => DarkModeProvider(_enabled);
  sync(bool isDarkMode) {
    _enabled = isDarkMode;
    notifyListeners();
  }

  settingsSync() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _enabled);
  }
}
