import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _enabled;
  Color _accentColor;

  ThemeProvider(bool enabled, Color color) {
    _enabled = enabled;
    _accentColor = color;
  }

  ThemeProvider.fromInfo(_Info info) {
    _enabled = info.isDarkMode;
    _accentColor = info.accentColor;
  }

  bool get isDarkMode => _enabled;

  toggleDarkMode() {
    HapticFeedback.selectionClick();
    _enabled = !_enabled;
    settingsSync();
    notifyListeners();
  }

  Color get accentColor => _accentColor;

  set accentColor(Color target) {
    _accentColor = target;
    settingsSync();
    notifyListeners();
  }

  reset() {
    _enabled = false;
    settingsSync();
    notifyListeners();
  }

  ThemeProvider copy() => ThemeProvider.fromInfo(info);

  sync(_Info info) {
    _accentColor = info.accentColor;
    _enabled = info.isDarkMode;
    notifyListeners();
  }

  _Info get info => _Info(accentColor: _accentColor, isDarkMode: _enabled);

  settingsSync() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _enabled);
    prefs.setInt('accentColor', _accentColor.value);
  }
}

class _Info {
  Color accentColor;
  bool isDarkMode;

  _Info({@required this.accentColor, @required this.isDarkMode});
}
