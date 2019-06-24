import 'package:textos/constants.dart';

class Favorite {
  Favorite(String fav)
      : textTitle = fav.split(';')[0],
        textPath = fav.split(';')[1],
        textImg = fav.split(';')[2] ?? placeholderImg;

  final String textTitle;
  final String textPath;
  final String textImg;

  String get textId => textPath.split('/')[textPath.split('/').length-1];
  String get string => textTitle + ';' + textPath + ';' + textImg;
}
