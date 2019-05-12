import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textos/Src/Providers/Providers.dart';
import 'package:textos/Src/TextContent.dart';
import 'package:textos/Views/TextCardView.dart';
import 'package:textos/Widgets/Widgets.dart';

class FavoritesProvider with ChangeNotifier {
  Set<String> _favoritesSet;

  FavoritesProvider(List<String> favorites) {
    _favoritesSet = favorites.toSet();
  }

  isFavorite(String favorite) => _favoritesSet.contains(favorite);

  add(String favorite) {
    _favoritesSet.add(favorite);
    notifyListeners();
  }

  remove(String favorite) {
    _favoritesSet.remove(favorite);
    notifyListeners();
  }

  clear() {
    _favoritesSet.clear();
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
          builder: (context) => TextCardView(
                textContent: TextContent.fromData(data),
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

  FavoritesProvider copy() => FavoritesProvider(_favoritesSet.toList());
}
