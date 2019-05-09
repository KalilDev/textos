import 'package:flutter/material.dart';
import 'package:textos/Src/Controllers/TagPageController.dart';
import 'package:vibration/vibration.dart';

class TextPageController {
  PageController pageController;

  TextPageController() {
    pageController = new PageController(viewportFraction: 0.85);
  }

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  void addListener(VoidCallback setState, TagPageController tagPageController) {
    pageController.addListener(() {
      int next = pageController.page.round();
      if (tagPageController.pageController.hasClients) {
        tagPageController.jump();
      }
      if (currentPage != next) {
        Vibration.vibrate(duration: 60);
        currentPage = next;
        setState();
      }
    });
  }

  bool isCurrent(int index) => index == currentPage;

  void dispose() {
    pageController.dispose();
  }

  @override
  String toString() {
    String page =
        pageController.hasClients ? pageController.page.toString() : 'null';
    return ('currentPage: ' +
        currentPage.toString() +
        '\n' +
        'pageController.page: ' +
        page +
        '\n' +
        'pageController.hasClients: ' +
        pageController.hasClients.toString() +
        '\n' +
        'pageController.hasListeners: ' +
        pageController.hasListeners.toString());
  }
}
