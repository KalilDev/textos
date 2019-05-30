import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textos/constants.dart';
import 'package:textos/src/mixins.dart';

class Content with Haptic {
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
    _text = data['text']
        .toString()
        .replaceAll('\^TAB', '         ')
        .replaceAll('\^NL', '\n');
  }

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
      time.day.toString() +
          '/' +
          time.month.toString() +
          '/' +
          time.year.toString();

  Map<int, int> _iterate(List<Match> list) {
    final Map<int, int> periods = <int, int>{};
    int i = 0;
    while (i * 2 < list.length) {
      periods[list[i * 2].end] = list[(i * 2) + 1].start;
      i++;
    }
    return periods;
  }

  List<TextSpan> formattedText(TextStyle style) {
    final RegExp italicRegex = RegExp(r'\_');
    final RegExp boldRegex = RegExp(r'\*');
    final RegExp strikeRegex = RegExp(r'\~');
    final RegExp monoRegex = RegExp(r'\`');

    final Map<int, int> italic =
    _iterate(italicRegex.allMatches(_text).toList());
    final Map<int, int> bold = _iterate(boldRegex.allMatches(_text).toList());
    final Map<int, int> strike =
    _iterate(strikeRegex.allMatches(_text).toList());
    final Map<int, int> mono = _iterate(monoRegex.allMatches(_text).toList());

    final Map<int, int> allMap = <int, int>{};
    if (italic != null)
      allMap.addAll(italic);
    if (bold != null)
      allMap.addAll(bold);
    if (strike != null)
      allMap.addAll(strike);
    if (mono != null)
      allMap.addAll(mono);

    final List<int> all = allMap.keys.toList();
    all.sort();

    final List<TextSpan> list = <TextSpan>[];
    int spanBoundary = 0;
    int i = 0;

    do {
      if (all.length - 1 < i) {
        list.add(TextSpan(
            text: _text.substring(spanBoundary, _text.length - 1),
            style: style));
        return list;
      } else {
        final int startIdx = all[i];

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
          final String text = _text.substring(startIdx, mono[startIdx]);
          list.add(TextSpan(
              style: style.copyWith(fontFamily: 'monospace'),
              text: text,
              recognizer: LongPressGestureRecognizer()
                ..onLongPress = () {
                  Clipboard.setData(ClipboardData(text: text));
                  selectItem();
                }));
          spanBoundary = mono[startIdx] + 1;
        }
        i++;
      }
    } while (spanBoundary < _text.length);
    return list;
  }
}
