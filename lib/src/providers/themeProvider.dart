import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/mixins.dart';

class ThemeProvider with ChangeNotifier, Haptic {
  ThemeProvider(bool enabled) {
    _enabled = enabled;
    _lightPrimaryColor = Colors.indigo.shade500;
    _darkPrimaryColor = Colors.indigo.shade200;
  }

  ThemeProvider.fromInfo(_Info info) {
    _enabled = info.isDarkMode;
    _darkPrimaryColor = info.darkPrimaryColor;
    _lightPrimaryColor = info.lightPrimaryColor;
  }

  bool _enabled;
  Color _lightPrimaryColor;
  Color _darkPrimaryColor;

  bool get isDarkMode => _enabled;

  void toggleDarkMode() {
    selectItem();
    _enabled = !_enabled;
    settingsSync();
    notifyListeners();
  }

  Color get darkPrimaryColor => _darkPrimaryColor;

  Color get lightPrimaryColor => _lightPrimaryColor;

  set accentColor(Color target) {
    _darkPrimaryColor = target;
    _lightPrimaryColor = target;
    settingsSync();
    notifyListeners();
  }

  void reset() {
    _enabled = false;
    _lightPrimaryColor = Colors.indigo.shade500;
    _darkPrimaryColor = Colors.indigo.shade200;
    settingsSync();
    notifyListeners();
  }

  ThemeProvider copy() => ThemeProvider.fromInfo(info);

  void sync(_Info info) {
    _darkPrimaryColor = info.darkPrimaryColor;
    _lightPrimaryColor = info.lightPrimaryColor;
    _enabled = info.isDarkMode;
    notifyListeners();
  }

  _Info get info => _Info(
      darkPrimaryColor: _darkPrimaryColor,
      lightPrimaryColor: _lightPrimaryColor,
      isDarkMode: _enabled);

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _enabled);
  }
}

class _Info {
  const _Info(
      {@required this.darkPrimaryColor,
      @required this.lightPrimaryColor,
      @required this.isDarkMode});

  final Color darkPrimaryColor;
  final Color lightPrimaryColor;
  final bool isDarkMode;
}
