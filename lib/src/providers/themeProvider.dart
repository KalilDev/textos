import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(bool enabled) {
    _enabled = enabled;
  }

  bool _enabled;

  bool get isDarkMode => _enabled;

  void toggleDarkMode() {
    _enabled = !_enabled;
    settingsSync();
    notifyListeners();
  }

  void reset() {
    _enabled = false;
    settingsSync();
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _enabled);
  }
}
