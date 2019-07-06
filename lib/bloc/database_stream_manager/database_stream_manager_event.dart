import 'package:meta/meta.dart';

@immutable
abstract class DatabaseStreamManagerEvent {}

class LoadedAuthors extends DatabaseStreamManagerEvent {}