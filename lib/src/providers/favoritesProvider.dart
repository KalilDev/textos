import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/favoritesHelper.dart';
import 'package:textos/src/mixins.dart';

class FavoritesProvider with ChangeNotifier, Haptic {
  FavoritesProvider(List<String> favorites, FavoritesHelper helper) {
    _helper = helper;
    _favoritesSet = favorites.toSet();
  }

  Set<String> _favoritesSet;
  FavoritesHelper _helper;

  bool isFavorite(String favorite) =>
      _favoritesSet.any((String string) => string.contains(favorite));

  void add(String favorite) {
    selectItem();
    _favoritesSet.add(favorite);
    settingsSync();
    _helper.atomicOperation(favorite, operation: AtomicOperation.add);
    notifyListeners();
  }

  void remove(String favorite) {
    selectItem();
    _favoritesSet.remove(favorite);
    settingsSync();
    _helper.atomicOperation(favorite, operation: AtomicOperation.remove);
    notifyListeners();
  }

  void clear() {
    selectItem();
    _favoritesSet.clear();
    settingsSync();
    _helper.syncDatabase(_favoritesSet.toList());
    notifyListeners();
  }

  Future<Content> getContent(String favorite) async {
    final DocumentSnapshot documentSnapshot =
    await Firestore.instance.document(_getPath(favorite)).get();
    final Map<String, dynamic> data = documentSnapshot.data;
    data['path'] = _getPath(favorite);
    openView();
    return Content.fromData(data);
  }

  void toggle(String favorite) {
    isFavorite(favorite) ? remove(favorite) : add(favorite);
  }

  String _getPath(String text) {
    return text.split(';')[1];
  }

  List<String> get favoritesList => _favoritesSet.toList();

  FavoritesProvider copy() =>
      FavoritesProvider(_favoritesSet.toList(), _helper);

  void sync(List<String> favoritesList) {
    _favoritesSet = favoritesList.toSet();
    notifyListeners();
  }

  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoritesSet.toList());
  }
}
