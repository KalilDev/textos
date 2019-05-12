import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlurProvider with ChangeNotifier {
  int _settings;

  BlurProvider(int settings) {
    _settings = settings;
  }

  static const List<int> settingsTable = [2, 3, 5];

  bool get drawerBlur => _settings % settingsTable[0] == 0;

  toggleDrawerBlur() {
    _settings = drawerBlur
        ? (_settings / settingsTable[0]).round()
        : (_settings * settingsTable[0]).round();
    settingsSync();
    notifyListeners();
  }

  bool get buttonsBlur => _settings % settingsTable[1] == 0;

  toggleButtonsBlur() {
    _settings = buttonsBlur
        ? (_settings / settingsTable[1]).round()
        : (_settings * settingsTable[1]).round();
    settingsSync();
    notifyListeners();
  }

  bool get textsBlur => _settings % settingsTable[2] == 0;

  toggleTextsBlur() {
    _settings = textsBlur
        ? (_settings / settingsTable[2]).round()
        : (_settings * settingsTable[2]).round();
    settingsSync();
    notifyListeners();
  }

  clearSettings() {
    _settings = 1;
    settingsSync();
    notifyListeners();
  }

  int get blurSettings => _settings;
  BlurProvider copy() => BlurProvider(_settings);
  sync(int blurSettings) {
    _settings = blurSettings;
    notifyListeners();
  }

  settingsSync() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('blurSettings', _settings);
  }
}
