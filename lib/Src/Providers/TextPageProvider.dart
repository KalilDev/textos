import 'package:flutter/foundation.dart';

class TextPageProvider with ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  set currentPage(int next) {
    _currentPage = next;
    notifyListeners();
  }
}
