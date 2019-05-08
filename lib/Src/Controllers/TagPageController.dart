import 'package:flutter/material.dart';
import 'package:textos/Src/Controllers/QueryController.dart';
import 'package:vibration/vibration.dart';

class TagPageController {
  PageController pageController;

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

      if (currentPage != next) {
        Vibration.vibrate(duration: 60);
        currentPage = next;
        authorCollection = metadatas[currentPage]['collection'];
        queryController.updateQuery();
        setState();
      }
    });
  }

  void setMetadata(List<Map<String, dynamic>> metadatas) {}

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
