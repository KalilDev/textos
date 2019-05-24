import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textos/constants.dart';

class Content {
  String title;
  String textPath;
  String imgUrl;
  String _text;
  String date;
  String music;
  int favoriteCount;

  bool get hasText => _text != 'null';

  bool get hasMusic => music != null;

  String stringDate(DateTime time) =>
      (time.day.toString() + '/' + time.month.toString() + '/' +
          time.year.toString());

  Content.fromData(Map data) {
    title = data['title'] ?? Constants.placeholderTitle;
    textPath = data['path'];
    imgUrl = data['img'] ?? Constants.placeholderImg;
    if (data['date'] == null) {
      date = stringDate(DateTime.now());
    } else if (data['date'] is String) {
      date = data['date'].toString().contains('/') ? data['date'] : stringDate(
          DateTime.parse(data['date'].toString()));
    }
    favoriteCount = data['favoriteCount'] ?? 0;
    music = data['music'];
    _text = data['text'].toString().replaceAll('\^TAB', '         ').replaceAll(
        '\^NL', '\n');
  }

  Map<int, int> _iterate(List<Match> list) {
    Map<int, int> periods = {};
    int i = 0;
    while (i * 2 < list.length) {
      periods[list[i * 2].end] = list[(i * 2) + 1].start;
      i++;
    }
    return periods;
  }

  List<TextSpan> formattedText(TextStyle style) {
    final italicRegex = new RegExp(r"\_");
    final boldRegex = new RegExp(r"\*");
    final strikeRegex = new RegExp(r"\~");
    final monoRegex = new RegExp(r"\`");

    final italic = _iterate(italicRegex.allMatches(_text).toList());
    final bold = _iterate(boldRegex.allMatches(_text).toList());
    final strike = _iterate(strikeRegex.allMatches(_text).toList());
    final mono = _iterate(monoRegex.allMatches(_text).toList());

    Map<int, int> allMap = {};
    if (italic != null) allMap.addAll(italic);
    if (bold != null) allMap.addAll(bold);
    if (strike != null) allMap.addAll(strike);
    if (mono != null) allMap.addAll(mono);

    List all = allMap.keys.toList();
    all.sort();

    List<TextSpan> list = [];
    int spanBoundary = 0;
    int i = 0;

    do {
      if (all.length - 1 < i) {
        list.add(TextSpan(
            text: _text.substring(spanBoundary, _text.length - 1),
            style: style));
        return list;
      } else {
        final startIdx = all[i];

        if (startIdx > spanBoundary) {
          list.add(TextSpan(
              text: _text.substring(spanBoundary, startIdx - 1), style: style));
        }

        if (italic.containsKey(startIdx)) {
          list.add(TextSpan(
              style: style.copyWith(fontStyle: FontStyle.italic),
              text: _text.substring(startIdx, italic[startIdx])));
          spanBoundary = italic[startIdx] + 1;
        } else if (bold.containsKey(startIdx)) {
          list.add(TextSpan(
              style: style.copyWith(fontWeight: FontWeight.bold),
              text: _text.substring(startIdx, bold[startIdx])));
          spanBoundary = bold[startIdx] + 1;
        } else if (strike.containsKey(startIdx)) {
          list.add(TextSpan(
              style: style.copyWith(decoration: TextDecoration.lineThrough),
              text: _text.substring(startIdx, strike[startIdx])));
          spanBoundary = strike[startIdx] + 1;
        } else if (mono.containsKey(startIdx)) {
          final text = _text.substring(startIdx, mono[startIdx]);
          list.add(TextSpan(
              style: style.copyWith(fontFamily: 'monospace'),
              text: text,
              recognizer: LongPressGestureRecognizer()
                ..onLongPress = () {
                  Clipboard.setData(new ClipboardData(text: text));
                  HapticFeedback.heavyImpact();
                }));
          spanBoundary = mono[startIdx] + 1;
        }
        i++;
      }
    } while (spanBoundary < _text.length);
    return list;
  }
}
