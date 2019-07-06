import 'package:meta/meta.dart';

@immutable
abstract class TitleManagerEvent {}

class UpdateTitle extends TitleManagerEvent {
  UpdateTitle({@required this.title});
  final String title;
}

class UpdateAuthorName extends TitleManagerEvent {
  UpdateAuthorName({@required this.authorName});
  final String authorName;
}
