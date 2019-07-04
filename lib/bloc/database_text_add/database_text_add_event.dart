import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DatabaseTextAddEvent extends Equatable {
  DatabaseTextAddEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

String _normalize(int date) {
  if (date < 10)
    return '0' + date.toString();
  return date.toString();
}

class DateChanged extends DatabaseTextAddEvent {
  DateChanged({int day, int month, int year}) : date = year.toString() + _normalize(month) + _normalize(day);
  final String date;
}
class TextChanged extends DatabaseTextAddEvent {
  TextChanged(@required this.text);
  String text;
}
class TitleChanged extends DatabaseTextAddEvent {
  TitleChanged(@required this.title);
  String title;
}
class MusicChanged extends DatabaseTextAddEvent {}
class PhotoChanged extends DatabaseTextAddEvent {}
class TagsChanged extends DatabaseTextAddEvent {}
