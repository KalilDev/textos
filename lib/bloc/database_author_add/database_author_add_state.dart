import 'package:meta/meta.dart';

@immutable
abstract class DatabaseAuthorAddState {
}

class AddAuthorState extends DatabaseAuthorAddState {}
class AddAuthorLoadingState extends DatabaseAuthorAddState {}
class ModifyAuthorState extends DatabaseAuthorAddState {}
