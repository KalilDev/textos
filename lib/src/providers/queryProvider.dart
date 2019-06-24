import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class QueryInfoProvider with ChangeNotifier {
  String _collection;
  String _tag;
  int _currentPage;

  String get collection => _collection ?? 'aBsVwogsjyUk7QISuKfAHOXsSdG2';

  String get tag => _tag ?? textAllTag;

  int get currentPage => _currentPage ?? 0;

  set collection(String newCollection) {
    _collection = newCollection;
    notifyListeners();
  }

  set tag(String newTag) {
    _tag = newTag;
    notifyListeners();
  }

  set currentPage(int newPage) {
    _currentPage = newPage;
    notifyListeners();
  }
}
