import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DatabaseAuthorStreamManagerEvent extends Equatable {
  DatabaseAuthorStreamManagerEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class FinishedLoading extends DatabaseAuthorStreamManagerEvent {
  FinishedLoading({this.tag}) : super(<dynamic>[tag]);
  final String tag;
}

