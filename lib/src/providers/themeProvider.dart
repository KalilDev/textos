import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider(bool enabled) {
    _enabled = enabled;
    _idx = 1;
  }
  int _idx;

  final List<KalilTheme> _darkThemes = const <KalilTheme>[
    KalilTheme(Color(0xFFdad19f), Color(0xFFa8a070), Color(0xFF0C0D11)),
    KalilTheme(Color(0xFF9fc5da), Color(0xFF6f94a8), Color(0xFF0C0D11)),
    KalilTheme(Color(0xFFb49fda), Color(0xFF8470a8), Color(0xFF0C0D11)),
    KalilTheme(Color(0xFFd19fda), Color(0xFF9f70a8), Color(0xFF0C0D11)),
    KalilTheme(Color(0xFFda9fa8), Color(0xFFa77079), Color(0xFF0C0D11))
  ];

  final List<KalilTheme> _lightThemes = const <KalilTheme>[
    KalilTheme(Color(0xFFb5a33f), Color(0xFFe9d46e), Colors.black),
    KalilTheme(Color(0xFF3f8cb5), Color(0xFF75bce7), Colors.black),
    KalilTheme(Color(0xFF683fb5), Color(0xFF341384), Colors.white),
    KalilTheme(Color(0xFFa33fb5), Color(0xFF710085), Colors.white),
    KalilTheme(Color(0xFFb53f51), Color(0xFF800229), Colors.white)
  ];

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

  void changeTheme() {
    if (_idx + 1 < _lightThemes.length) {
      _idx++;
    } else {
      _idx = 0;
    }
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _enabled);
  }

  KalilTheme get darkTheme => _darkThemes[_idx];
  KalilTheme get lightTheme => _lightThemes[_idx];
}

class KalilTheme {
  const KalilTheme(this.secondary, this.secondaryVariant, this.onSecondary);
  final Color secondary;
  final Color secondaryVariant;
  final Color onSecondary;
}
