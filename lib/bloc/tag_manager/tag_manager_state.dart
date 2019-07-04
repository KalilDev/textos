import 'package:meta/meta.dart';

@immutable
abstract class TagManagerState {}

class TagLoadingState extends TagManagerState {}
class TagLoadedState extends TagManagerState {}
