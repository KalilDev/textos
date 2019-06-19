import 'package:textos/constants.dart';

class Favorite {
  Favorite(String fav)
      : textTitle = fav.split(';')[0],
        textCollection = fav.split(';')[1].split('/')[0],
        textId = fav.split(';')[1].split('/')[1],
        textImg = fav.split(';')[2] ?? placeholderImg;

  final String textTitle;
  final String textCollection;
  final String textId;
  final String textImg;
  String get textPath => textCollection + '/' + textId;

  String get string => textTitle + ';' + textPath + ';' + textImg;
}
