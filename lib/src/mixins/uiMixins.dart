import 'package:flutter/material.dart';

mixin TextThemeMixin {
  TextStyle textTitleStyle(TextTheme tt) => tt.display1;

  TextStyle settingsTitleStyle(TextTheme tt) => tt.subhead;

  TextStyle settingsDescriptionStyle(TextTheme tt) => settingsTitleStyle(tt)
      .copyWith(color: settingsTitleStyle(tt).color.withAlpha(190));
}
