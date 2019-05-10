class BlurSettings {
  int blurSettings;

  BlurSettings(this.blurSettings);

  static const List<int> settingsTable = [2, 3, 5];

  bool get drawerBlur => blurSettings % settingsTable[0] == 0;

  set drawerBlur(bool target) {
    print(drawerBlur);
    print(target);
    print(blurSettings);
    if (drawerBlur != target) {
      blurSettings = drawerBlur
          ? (blurSettings / settingsTable[0]).round()
          : (blurSettings * settingsTable[0]).round();
    }
  }

  bool get buttonsBlur => blurSettings % settingsTable[1] == 0;

  set buttonsBlur(bool target) {
    print(drawerBlur);
    print(target);
    print(blurSettings);
    if (buttonsBlur != target) {
      blurSettings = buttonsBlur
          ? (blurSettings / settingsTable[1]).round()
          : (blurSettings * settingsTable[1]).round();
    }
  }

  bool get textsBlur => blurSettings % settingsTable[2] == 0;

  set textsBlur(bool target) {
    print(drawerBlur);
    print(target);
    print(blurSettings);
    if (textsBlur != target) {
      blurSettings = textsBlur
          ? (blurSettings / settingsTable[2]).round()
          : (blurSettings * settingsTable[2]).round();
    }
  }

  @override
  String toString() {
    return ('drawerBlur: ' +
        drawerBlur.toString() +
        '\n' +
        'buttonsBlur: ' +
        buttonsBlur.toString() +
        '\n' +
        'textsBlur: ' +
        textsBlur.toString());
  }
}
