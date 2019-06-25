import 'package:flutter/foundation.dart';
import 'package:textos/constants.dart';

import '../textUtils.dart';
import 'favorite.dart';

class Content {
  Content(
      {@required this.title,
      @required String date,
      @required String imgUrl,
      @required this.text,
      @required this.music,
      @required this.tags})
      : _date = date,
        _imgUrl = imgUrl;
  Content.fromFav(Favorite fav) {
    title = fav.textTitle;
    textPath = fav.textPath;
    _imgUrl = fav.textImg;
  }

  Content.fromData(Map<String, dynamic> data) {
    title = data['title'] ?? placeholderTitle;
    textPath = data['path'];
    _imgUrl = data['img'];
    _date = data['date'];
    favoriteCount = data['favoriteCount'] ?? 0;
    music = data['music'];
    text = data['text'];
    tags = data['tags'] ?? <dynamic>[];
  }

  String title;
  String textPath;
  String _imgUrl;
  String text;
  String _date;
  String music;
  List<dynamic> tags;
  int favoriteCount;

  String get imgUrl => _imgUrl ?? placeholderImg;

  String get date {
    if (_date == null) {
      return stringDate(DateTime.now());
    } else if (_date is String) {
      return _date.toString().contains('/')
          ? _date
          : stringDate(DateTime.parse(_date.toString()));
    }
    return stringDate(DateTime.now());
  }

  bool get hasText => text != null;
  bool get hasMusic => music != null;
  bool get canFavorite => textPath != null;

  Map<String, dynamic> toData() => <String, dynamic>{
        'date': _date,
        'title': title,
        'text': text,
        'tags': tags,
        'img': _imgUrl,
      };

  Favorite get favorite => Favorite(title + ';' + textPath + ';' + imgUrl);
}
