import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DatabaseTextAddState extends Equatable {
  DatabaseTextAddState([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class TextEditState extends DatabaseTextAddState {}

class TextCreateState extends DatabaseTextAddState {}
