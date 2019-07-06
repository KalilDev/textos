import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DatabaseAuthorStreamManagerState extends Equatable {
  DatabaseAuthorStreamManagerState([List<dynamic> props = const <dynamic>[]]) : super(props);
}


class LoadingTextsStream extends DatabaseAuthorStreamManagerState {
  LoadingTextsStream({this.tag}) : super(<dynamic>[tag]);
  final String tag;
}
class LoadedTextsStream extends DatabaseAuthorStreamManagerState {
  LoadedTextsStream({this.tag}) : super(<dynamic>[tag]);
  final String tag;
}
