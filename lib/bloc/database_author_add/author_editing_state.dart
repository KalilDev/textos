import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthorEditingState extends Equatable {
  AuthorEditingState([List props = const <dynamic>[]]) : super(props);
}

class ShowingChild extends AuthorEditingState {}
class ShowingEdit extends AuthorEditingState {}
