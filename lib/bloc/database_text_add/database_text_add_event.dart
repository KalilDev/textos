import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DatabaseTextAddEvent extends Equatable {
  DatabaseTextAddEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class DateChanged extends DatabaseTextAddEvent {
  DateChanged({int day, int month, int year}) : date = year.toString() + _normalize(month) + _normalize(day);
  final String date;

  @override
  String toString() => 'Date Changed to: ' + date;
}
class TextChanged extends DatabaseTextAddEvent {
  TextChanged({@required this.text});
  final String text;

  @override
  String toString() => 'Text Changed';
}
class TitleChanged extends DatabaseTextAddEvent {
  TitleChanged({@required this.title});
  final String title;

  @override
  String toString() => 'Title Changed to: ' + title;
}

String _normalize(int date) {
  if (date < 10)
    return '0' + date.toString();
  return date.toString();
}