import 'package:textos/Src/Constants.dart';

class TextContent {
  String title;
  String textPath;
  String imgUrl;
  String text;
  String date;
  int favoriteCount;

  TextContent.fromData(Map data) {
    title = data['title'] ?? Constants.placeholderTitle;
    textPath = data['path'];
    imgUrl = data['img'] ?? Constants.placeholderImg;
    text = data['text'] ?? Constants.placeholderText;
    date = data['date'] ?? Constants.placeholderDate;
    favoriteCount = data['favoriteCount'] ?? 0;
  }
}
