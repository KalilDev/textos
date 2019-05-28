import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalil_widgets/kalil_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/favoritesHelper.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView.dart';

class FavoritesProvider with ChangeNotifier {
  FavoritesProvider(List<String> favorites, FavoritesHelper helper) {
    _helper = helper;
    _favoritesSet = favorites.toSet();
  }

  Set<String> _favoritesSet;
  FavoritesHelper _helper;

  bool isFavorite(String favorite) =>
      _favoritesSet.any((String string) => string.contains(favorite));

  void add(String favorite) {
    HapticFeedback.selectionClick();
    _favoritesSet.add(favorite);
    settingsSync();
    _helper.addFavorite(favorite);
    notifyListeners();
  }

  void remove(String favorite) {
    HapticFeedback.selectionClick();
    _favoritesSet.remove(favorite);
    settingsSync();
    _helper.removeFavorite(favorite);
    notifyListeners();
  }

  void clear() {
    HapticFeedback.selectionClick();
    _favoritesSet.clear();
    settingsSync();
    _helper.syncDatabase(_favoritesSet.toList());
    notifyListeners();
  }

  Future<void> open(String favorite, BuildContext context) async {
    final List<dynamic> providerList = <dynamic>[
      Provider.of<FavoritesProvider>(context),
      Provider.of<ThemeProvider>(context),
      Provider.of<BlurProvider>(context),
      Provider.of<TextSizeProvider>(context),
    ];
    final DocumentSnapshot documentSnapshot =
    await Firestore.instance.document(_getPath(favorite)).get();
    final Map<String, dynamic> data = documentSnapshot.data;
    data['path'] = _getPath(favorite);
    Navigator.pop(context);
    HapticFeedback.selectionClick();
    final List<dynamic> result = await Navigator.push(
      context,
      FadeRoute<List<dynamic>>(
          builder: (BuildContext context) =>
              CardView(
                textContent: Content.fromData(data),
                favoritesProvider: providerList[0].copy(),
                darkModeProvider: providerList[1].copy(),
                blurProvider: providerList[2].copy(),
                textSizeProvider: providerList[3].copy(),
              )),
    );
    final List<dynamic> resultList = result;
    providerList[0].sync(resultList[0]);
    providerList[1].sync(resultList[1]);
    providerList[2].sync(resultList[2]);
    providerList[3].sync(resultList[3]);
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
