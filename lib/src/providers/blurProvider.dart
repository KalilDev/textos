import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/mixins.dart';

class BlurProvider with ChangeNotifier, Haptic {
  BlurProvider(int settings) {
    _settings = settings;
  }

  int _settings;

  static const List<int> settingsTable = <int>[2, 3, 5];

  bool get drawerBlur => _settings % settingsTable[0] == 0;

  void toggleDrawerBlur() {
    selectItem();
    _settings = drawerBlur
        ? (_settings / settingsTable[0]).round()
        : (_settings * settingsTable[0]).round();
    settingsSync();
    notifyListeners();
  }

  bool get buttonsBlur => _settings % settingsTable[1] == 0;

  void toggleButtonsBlur() {
    selectItem();
    _settings = buttonsBlur
        ? (_settings / settingsTable[1]).round()
        : (_settings * settingsTable[1]).round();
    settingsSync();
    notifyListeners();
  }

  bool get textsBlur => _settings % settingsTable[2] == 0;

  void toggleTextsBlur() {
    selectItem();
    _settings = textsBlur
        ? (_settings / settingsTable[2]).round()
        : (_settings * settingsTable[2]).round();
    settingsSync();
    notifyListeners();
  }

  void clearSettings() {
    _settings = 1;
    settingsSync();
    notifyListeners();
  }

  int get blurSettings => _settings;

  BlurProvider copy() => BlurProvider(_settings);

  void sync(int blurSettings) {
    _settings = blurSettings;
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('blurSettings', _settings);
  }
}
