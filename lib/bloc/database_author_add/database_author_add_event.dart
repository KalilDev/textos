import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DatabaseAuthorAddEvent extends Equatable {
  DatabaseAuthorAddEvent([List props = const <dynamic>[]]) : super(props);
}

class AuthorIDLoaded extends DatabaseAuthorAddEvent {
  AuthorIDLoaded({@required this.authorID}) : super(<dynamic>[authorID]);
  final String authorID;
}

class AuthorTitleUpdate extends DatabaseAuthorAddEvent {
  AuthorTitleUpdate({@required this.title}) : super(<dynamic>[title]);
  final String title;
}

class AuthorNameUpdate extends DatabaseAuthorAddEvent {
  AuthorNameUpdate({@required this.authorName}) : super(<dynamic>[authorName]);
  final String authorName;
}

class AuthorTagAdd extends DatabaseAuthorAddEvent {
  AuthorTagAdd(this.tag) : super(<dynamic>[tag]);
  final String tag;
}

class AuthorTagRemove extends DatabaseAuthorAddEvent {
  AuthorTagRemove(this.tag) : super(<dynamic>[tag]);
  final int tag;
}

class AuthorTagModify extends DatabaseAuthorAddEvent {
  AuthorTagModify(this.index,{@required this.tag}) : super(<dynamic>[tag, index]);
  final String tag;
  final int index;
}

class AuthorUpload extends DatabaseAuthorAddEvent {}
class UploadFinished extends DatabaseAuthorAddEvent {}