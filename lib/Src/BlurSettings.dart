import 'package:flutter/material.dart';

class BlurSettingsParser {
  int blurSettings;

  BlurSettingsParser({@required this.blurSettings});

  static const List<double> settingsTable = [2.0, 3.0, 5.0];

  bool getDrawerBlur() {
    // Return true if drawer blur is enabled
    return blurSettings % settingsTable[0] == 0;
  }

  bool getButtonsBlur() {
    return blurSettings % settingsTable[1] == 0;
  }

  bool getTextsBlur() {
    return blurSettings % settingsTable[2] == 0;
  }
}
