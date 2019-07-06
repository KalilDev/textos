import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthorEditingEvent extends Equatable {
  AuthorEditingEvent([List props = const <dynamic>[]]) : super(props);
}

class ShowEditing extends AuthorEditingEvent {}
class ShowChild extends AuthorEditingEvent {}
