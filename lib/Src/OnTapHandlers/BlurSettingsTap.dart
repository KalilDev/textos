import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:textos/Src/BlurSettings.dart';
import 'package:textos/main.dart';

class BlurSettingsTap {
  Store<AppStateMain> store;

  BlurSettingsTap({@required this.store});

  void setDrawerBlur() {
    BlurSettings settings = BlurSettings(store.state.blurSettings);
    settings.drawerBlur = !settings.drawerBlur;
    store.dispatch(UpdateBlurSettings(integer: settings.blurSettings));
  }

  void setButtonsBlur() {
    BlurSettings settings = BlurSettings(store.state.blurSettings);
    settings.buttonsBlur = !settings.buttonsBlur;
    store.dispatch(UpdateBlurSettings(integer: settings.blurSettings));
  }

  void setTextsBlur() {
    BlurSettings settings = BlurSettings(store.state.blurSettings);
    settings.textsBlur = !settings.textsBlur;
    store.dispatch(UpdateBlurSettings(integer: settings.blurSettings));
  }
}
