import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class TitleManagerBloc extends Bloc<TitleManagerEvent, TitleManagerState> {
  TitleManagerBloc({this.authorName, this.title});

  String authorName;
  String title;

  @override
  TitleManagerState get initialState => MutableTitleManagerState();

  @override
  Stream<TitleManagerState> mapEventToState(
    TitleManagerEvent event,
  ) async* {
    if (event is UpdateTitle) {
      title = event.title;
      yield MutableTitleManagerState();
    }

    if (event is UpdateAuthorName) {
      authorName = event.authorName;
      yield MutableTitleManagerState();
    }
  }
}
