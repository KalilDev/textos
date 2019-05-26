import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class QueryInfoProvider with ChangeNotifier {
  String _collection;
  String _tag;

  String get collection => _collection != null ? _collection : 'stories';

  String get tag => _tag != null ? _tag : Constants.textAllTag;

  set collection(String newCollection) {
    _collection = newCollection;
    notifyListeners();
  }

  set tag(String newTag) {
    _tag = newTag;
    notifyListeners();
  }
}