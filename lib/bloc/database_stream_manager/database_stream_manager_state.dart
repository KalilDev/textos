import 'package:meta/meta.dart';

@immutable
abstract class DatabaseStreamManagerState {}

class LoadingAuthorsStream extends DatabaseStreamManagerState {}
class LoadedAuthorsStream extends DatabaseStreamManagerState {}
