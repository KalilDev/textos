import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

List<TextSpan> formattedText(String _text, {TextStyle style}) {
  final String text =
      _text.replaceAll('\^TAB', '         ').replaceAll('\^NL', '\n');
  final RegExp italicRegex = RegExp(r'\_');
  final RegExp boldRegex = RegExp(r'\*');
  final RegExp strikeRegex = RegExp(r'\~');
  final RegExp monoRegex = RegExp(r'\`');

  final Map<int, int> italic = _iterate(italicRegex.allMatches(text).toList());
  final Map<int, int> bold = _iterate(boldRegex.allMatches(text).toList());
  final Map<int, int> strike = _iterate(strikeRegex.allMatches(text).toList());
  final Map<int, int> mono = _iterate(monoRegex.allMatches(text).toList());

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
          text: text.substring(spanBoundary, text.length), style: style));
      return list;
    } else {
      final int startIdx = all[i];

      if (startIdx > spanBoundary) {
        list.add(TextSpan(
            text: text.substring(spanBoundary, startIdx - 1), style: style));
      }

      if (italic.containsKey(startIdx)) {
        list.add(TextSpan(
            style: style.copyWith(fontStyle: FontStyle.italic),
            text: text.substring(startIdx, italic[startIdx])));
        spanBoundary = italic[startIdx] + 1;
      } else if (bold.containsKey(startIdx)) {
        list.add(TextSpan(
            style: style.copyWith(fontWeight: FontWeight.bold),
            text: text.substring(startIdx, bold[startIdx])));
        spanBoundary = bold[startIdx] + 1;
      } else if (strike.containsKey(startIdx)) {
        list.add(TextSpan(
            style: style.copyWith(decoration: TextDecoration.lineThrough),
            text: text.substring(startIdx, strike[startIdx])));
        spanBoundary = strike[startIdx] + 1;
      } else if (mono.containsKey(startIdx)) {
        final String monoText = text.substring(startIdx, mono[startIdx]);
        list.add(TextSpan(
            style: style.copyWith(fontFamily: 'monospace'),
            text: monoText,
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () {
                HapticFeedback.heavyImpact();
                Clipboard.setData(ClipboardData(text: monoText));
              }));
        spanBoundary = mono[startIdx] + 1;
      }
      i++;
    }
  } while (spanBoundary < text.length);
  return list;
}
