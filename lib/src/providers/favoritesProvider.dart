import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textos/src/content.dart';
import 'package:textos/src/favoritesHelper.dart';
import 'package:textos/src/providers.dart';
import 'package:textos/ui/cardView/cardView.dart';
import 'package:textos/ui/widgets.dart';

class FavoritesProvider with ChangeNotifier {
  Set<String> _favoritesSet;
  FavoritesHelper _helper;

  void streamTransformer(data, EventSink sink) {
    Map<String, dynamic> localdata = data;
    /*List<String> favoritedList = [];
    _favoritesSet.toList().forEach((favorite) {
      favoritedList.add(favorite.split(';')[1].replaceAll('/', '_'));
    });
    print(favoritedList);
    print(localdata.keys.toList());
    favoritedList.forEach((key) {
      print('summed one at: ' + key);
      localdata[key] = localdata[key] + 1;
    });*/
    sink.add(localdata);
  }

  FavoritesProvider(List<String> favorites, FavoritesHelper helper) {
    _helper = helper;
    _favoritesSet = favorites.toSet();
  }

  isFavorite(String favorite) =>
      _favoritesSet.any((string) => string.contains(favorite));

  add(String favorite) {
    _favoritesSet.add(favorite);
    settingsSync();
    _helper.addFavorite(favorite);
    notifyListeners();
  }

  remove(String favorite) {
    _favoritesSet.remove(favorite);
    settingsSync();
    _helper.removeFavorite(favorite);
    notifyListeners();
  }

  clear() {
    _favoritesSet.clear();
    settingsSync();
    _helper.syncDatabase(_favoritesSet.toList());
    notifyListeners();
  }

  open(String favorite, BuildContext context) async {
    final documentSnapshot =
    await Firestore.instance.document(_getPath(favorite)).get();
    var data = documentSnapshot.data;
    data['path'] = _getPath(favorite);
    Navigator.pop(context);
    Navigator.push(
      context,
      FadeRoute(
          builder: (context) =>
              CardView(
            textContent: Content.fromData(data),
            darkModeProvider: Provider.of<DarkModeProvider>(context).copy(),
            blurProvider: Provider.of<BlurProvider>(context).copy(),
            textSizeProvider: Provider.of<TextSizeProvider>(context).copy(),
            favoritesProvider: this,
          )),
    );
  }

  toggle(String favorite) {
    isFavorite(favorite) ? remove(favorite) : add(favorite);
  }

  String _getPath(String text) {
    return text.split(';')[1];
  }

  List get favoritesList => _favoritesSet.toList();

  FavoritesProvider copy() =>
      FavoritesProvider(_favoritesSet.toList(), _helper);
  sync(List favoritesList) {
    _favoritesSet = favoritesList.toSet();
    notifyListeners();
  }

  settingsSync() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favoritesSet.toList());
  }
}
