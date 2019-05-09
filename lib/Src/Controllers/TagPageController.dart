import 'package:flutter/material.dart';
import 'package:textos/Src/Controllers/QueryController.dart';
import 'package:vibration/vibration.dart';

class TagPageController {
  PageController pageController;
  bool shouldJump = false;
  bool justJumped = false;

  TagPageController() {
    pageController = new PageController(viewportFraction: 0.90);
  }

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  String authorCollection = 'stories';
  List<Map<String, dynamic>> metadatas;

  void addListener(VoidCallback setState, QueryController queryController) {
    pageController.addListener(() {
      int next = pageController.page.round();

      if (justJumped) {
        if (next == currentPage) {
          justJumped = false;
        }
      } else {
        if (currentPage != next) {
          Vibration.vibrate(duration: 60);
          currentPage = next;
          authorCollection =
              metadatas[currentPage]['collection'] ?? authorCollection;
          queryController.updateQuery();
          setState();
        }
      }
    });
  }

  void setMetadata(List<Map<String, dynamic>> metadatas) {}

  bool isCurrent(int index) => index == currentPage;

  void dispose() {
    pageController.dispose();
  }

  void jump() {
    if (shouldJump) {
      shouldJump = false;
      justJumped = true;
      pageController.jumpToPage(currentPage);
      Vibration.vibrate(duration: 60);
    }
  }

  @override
  String toString() {
    String page;
    try {
      page = pageController.page.toString();
    } catch (e) {
      page = 'null';
    }
    return ('currentPage: ' +
        currentPage.toString() +
        '\n' +
        'shouldJump: ' +
        shouldJump.toString() +
        '\n' +
        'justJumped: ' +
        justJumped.toString() +
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
