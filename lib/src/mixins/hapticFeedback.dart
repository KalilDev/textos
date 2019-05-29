import 'package:flutter/services.dart';

mixin Haptic {
  void openView() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }

  void scrollFeedback() {
    HapticFeedback.lightImpact();
  }

  void selectItem() {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
  }
}
