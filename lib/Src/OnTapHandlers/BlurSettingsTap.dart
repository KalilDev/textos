import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/main.dart';

class BlurSettingsTap {
  Store<AppStateMain> store;

  BlurSettingsTap({@required this.store});

  void setDrawerBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble =
        BlurSettingsParser(blurSettings: store.state.blurSettings)
                .getDrawerBlur()
            ? currentSettings / BlurSettingsParser.settingsTable[0]
            : currentSettings * BlurSettingsParser.settingsTable[0];
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }

  void setButtonsBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble =
        BlurSettingsParser(blurSettings: store.state.blurSettings)
                .getButtonsBlur()
            ? currentSettings / BlurSettingsParser.settingsTable[1]
            : currentSettings * BlurSettingsParser.settingsTable[1];
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }

  void setTextsBlur() {
    final int currentSettings = store.state.blurSettings;
    double settingsDouble =
        BlurSettingsParser(blurSettings: store.state.blurSettings)
                .getTextsBlur()
            ? currentSettings / BlurSettingsParser.settingsTable[2]
            : currentSettings * BlurSettingsParser.settingsTable[2];
    store.dispatch(UpdateBlurSettings(integer: settingsDouble.round()));
  }
}
