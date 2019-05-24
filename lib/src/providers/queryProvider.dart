import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:textos/constants.dart';

class QueryProvider with ChangeNotifier {
  String _collection = 'stories';
  bool disposed;
  String _tag = Constants.textAllTag;
  Query _query;
  int _currentTagPage = 0;
  bool shouldAnimate = false;

  Firestore _db = Firestore.instance;

  QueryProvider() {
    _query = _db.collection(_collection).orderBy('date', descending: true);
    disposed = false;
  }

  Stream get dataStream =>
      _query.snapshots().map((list) => list.documents.map((doc) {
            final Map data = doc.data;
            data['path'] = doc.reference.path;
            data['favoriteCount'] = 0;
            return data;
          }));

  String get currentTag => _tag;

  int get currentTagPage => _currentTagPage != null ? _currentTagPage : 0;

  set currentTagPage(int next) {
    _currentTagPage = next;
    notifyListeners();
  }

  void updateStream(Map params) {
    _collection = params['collection'] ?? _collection;
    final tag = params['tag'];
    if (tag != null) {
      _query =
          _db.collection(_collection).where('tags', arrayContains: tag).orderBy(
              'date', descending: true);
      _tag = tag;
    } else {
      _query = _db.collection(_collection).orderBy('date', descending: true);
      _tag = Constants.textAllTag;
    }
    shouldAnimate = true;
    notifyListeners();
  }
}
