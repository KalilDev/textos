import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/main.dart';

class BlurSettings {
  Store<AppStateMain> store;

  BlurSettings({@required this.store});

  List<double> settingsTable = [2.0, 3.0, 5.0];

  bool getDrawerBlur() {
    // Return true if drawer blur is enabled
    return store.state.blurSettings % settingsTable[0] == 0;
  }

  void setDrawerBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble = getDrawerBlur()
        ? currentSettings / settingsTable[0]
        : currentSettings * settingsTable[0];
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }

  bool getButtonsBlur() {
    return store.state.blurSettings % settingsTable[1] == 0;
  }

  void setButtonsBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble = getButtonsBlur() ? currentSettings /
        settingsTable[1] : currentSettings * settingsTable[1];
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }

  bool getTextsBlur() {
    return store.state.blurSettings % settingsTable[2] == 0;
  }

  void setTextsBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble = getTextsBlur()
        ? currentSettings / settingsTable[2]
        : currentSettings * settingsTable[2];
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }
}
