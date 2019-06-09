import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlurProvider with ChangeNotifier {
  BlurProvider(int settings) {
    _settings = settings;
  }

  int _settings;

  static const List<int> settingsTable = <int>[3, 5];

  bool get buttonsBlur => _settings % settingsTable[0] == 0;

  void toggleButtonsBlur() {
    _settings = buttonsBlur
        ? (_settings / settingsTable[0]).round()
        : (_settings * settingsTable[0]).round();
    settingsSync();
    notifyListeners();
  }

  bool get textsBlur => _settings % settingsTable[1] == 0;

  void toggleTextsBlur() {
    _settings = textsBlur
        ? (_settings / settingsTable[1]).round()
        : (_settings * settingsTable[1]).round();
    settingsSync();
    notifyListeners();
  }

  void clearSettings() {
    _settings = 1;
    settingsSync();
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('blurSettings', _settings);
  }
}
