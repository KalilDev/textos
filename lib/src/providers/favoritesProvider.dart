import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/favoritesHelper.dart';
import 'package:textos/src/model/content.dart';
import 'package:textos/src/model/favorite.dart';

class FavoritesProvider with ChangeNotifier {
  FavoritesProvider(Set<Favorite> favorites, FavoritesHelper helper) {
    _helper = helper;
    _favoritesSet = favorites;
  }

  Set<Favorite> _favoritesSet;
  FavoritesHelper _helper;

  bool isFavorite(Favorite favorite) => _favoritesSet.any((Favorite fav) => fav.textId == favorite.textId);

  Set<Favorite> get favoritesSet => _favoritesSet;

  void add(Favorite favorite) {
    _favoritesSet.add(favorite);
    settingsSync();
    _helper.atomicOperation(title: favorite.textTitle, path: favorite.textPath, operation: AtomicOperation.add);
    notifyListeners();
  }

  void remove(Favorite favorite) {
    _favoritesSet.removeWhere((Favorite fav) => fav.textId == favorite.textId);
    settingsSync();
    _helper.atomicOperation(title: favorite.textTitle, path: favorite.textPath, operation: AtomicOperation.remove);
    notifyListeners();
  }

  void clear() {
    _favoritesSet.clear();
    settingsSync();
    _helper.syncDatabase(_favoritesSet);
    notifyListeners();
  }

  void logout() {
    _favoritesSet.clear();
    settingsSync();
  }

  Future<Content> getContent(Favorite favorite) async {
    final DocumentSnapshot documentSnapshot =
        await Firestore.instance.document(favorite.textPath).get();
    final Map<String, dynamic> data = documentSnapshot.data;
    data['path'] = favorite.textPath;
    return Content.fromData(data);
  }

  void toggle(Favorite favorite) {
    isFavorite(favorite) ? remove(favorite) : add(favorite);
  }
  
  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex)
      newIndex -= 1;
    final Favorite item = _favoritesSet.elementAt(oldIndex);
    final List<Favorite> favList = _favoritesSet.toList();
    favList.removeAt(oldIndex);
    favList.insert(newIndex, item);
    _favoritesSet = favList.toSet();
    settingsSync();
    notifyListeners();
  }
  
  Future<void> settingsSync() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> strings = <String>[];
    for (Favorite fav in _favoritesSet) {
      strings.add(fav.string);
    }
    prefs.setStringList('favorites', strings);
  }
}
