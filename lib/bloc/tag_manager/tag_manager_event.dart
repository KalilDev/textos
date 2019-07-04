import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TagManagerEvent extends Equatable {
  TagManagerEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class ToggleTag extends TagManagerEvent {
  ToggleTag({@required this.tag});
  final String tag;
}

class TagDBResponse extends TagManagerEvent {
  TagDBResponse(this.response);
  final List<String> response;
}
