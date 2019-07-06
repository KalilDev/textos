import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class AuthorEditingBloc extends Bloc<AuthorEditingEvent, AuthorEditingState> {
  @override
  AuthorEditingState get initialState => ShowingChild();

  @override
  Stream<AuthorEditingState> mapEventToState(
    AuthorEditingEvent event,
  ) async* {
    if (event is ShowChild) {
      yield ShowingChild();
    }

    if (event is ShowEditing) {
      yield ShowingEdit();
    }
  }
}
