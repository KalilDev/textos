import 'package:textos/constants.dart';

import '../textUtils.dart';
import 'favorite.dart';

class Content {
  Content.fromFav(Favorite fav) {
    isSliver = true;
  }
  Content.fromData(Map<String, dynamic> data) {
    title = data['title'] ?? placeholderTitle;
    textPath = data['path'];
    imgUrl = data['img'] ?? placeholderImg;
    if (data['date'] == null) {
      date = stringDate(DateTime.now());
    } else if (data['date'] is String) {
      date = data['date'].toString().contains('/')
          ? data['date']
          : stringDate(DateTime.parse(data['date'].toString()));
    }
    favoriteCount = data['favoriteCount'] ?? 0;
    music = data['music'];
    text = data['text']
        .toString();
    isSliver = false;
  }

  String title;
  String textPath;
  String imgUrl;
  String text;
  String date;
  String music;
  int favoriteCount;
  bool isSliver;

  bool get hasText => text != 'null';
  bool get hasMusic => music != null;

  Favorite get favorite => Favorite(title + ';' + textPath + ';' + imgUrl);
}
