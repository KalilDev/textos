import 'package:flutter/foundation.dart';
import 'package:textos/constants.dart';
import 'package:textos/model/favorite.dart';

import '../src/textUtils.dart';

class Content {
  Content(
      {@required this.title,
      @required this.rawDate,
      @required this.rawImgUrl,
      @required String text,
      @required this.music,
      @required this.tags})
      : text = text?.replaceAll('\n', '^NL');

  Content.fromFav(Favorite fav) {
    title = fav.textTitle;
    textPath = fav.textPath;
    rawImgUrl = fav.textImg;
  }

  Content.fromData(Map<String, dynamic> data) {
    title = data['title'] ?? placeholderTitle;
    textPath = data['path'];
    rawImgUrl = data['img'];
    rawDate = data['date'];
    favoriteCount = data['favoriteCount'] ?? 0;
    music = data['music'];
    text = data['text'];
    tags = <String>[];
    final List<dynamic> temp = data['tags'] ?? <dynamic>[];
    for (dynamic tag in temp) {
      tags.add(tag.toString());
    }
  }

  String title;
  String textPath;
  String rawImgUrl;
  String text;
  String rawDate;
  String music;
  List<String> tags;
  int favoriteCount;

  String get imgUrl => rawImgUrl ?? placeholderImg;

  String get date {
    if (rawDate == null) {
      return stringDate(DateTime.now());
    } else if (rawDate is String) {
      return rawDate.toString().contains('/')
          ? rawDate
          : stringDate(DateTime.parse(rawDate.toString()));
    }
    return stringDate(DateTime.now());
  }

  bool get hasText => text != null;
  bool get hasMusic => music != null;
  bool get canFavorite => textPath != null;

  Map<String, dynamic> toData() => <String, dynamic>{
        'date': rawDate,
        'title': title,
        'text': text,
        'tags': tags,
        'img': rawImgUrl,
        'music': music
      };

  Favorite get favorite => Favorite(title + ';' + textPath + ';' + imgUrl);
}
