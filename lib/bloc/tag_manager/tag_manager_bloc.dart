import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'bloc.dart';

class TagManagerBloc extends Bloc<TagManagerEvent, TagManagerState> {
  TagManagerBloc({List<String> activeTags}) : activeTags = activeTags ?? <String>[];
  List<String> activeTags;
  List<String> allTags;

  Future<void> _fetchFromDB() async {
    final List<String> localTags = <String>[];
    final FirebaseUser user =
    await FirebaseAuth.instance.currentUser();
    final List<dynamic> dbTags = await Firestore.instance
        .collection('texts')
        .document(user.uid)
        .get()
        .then<List<dynamic>>((DocumentSnapshot snap) => snap.data['tags']);
    for (dynamic tag in dbTags)
      localTags.add(tag.toString());
    dispatch(TagDBResponse(localTags));
  }

  @override
  TagManagerState get initialState {
    _fetchFromDB();
    return TagLoadingState();
  }

  @override
  Stream<TagManagerState> mapEventToState(
    TagManagerEvent event,
  ) async* {
    if (event is TagDBResponse) {
      allTags = event.response;
      yield TagLoadedState();
    }

    if (event is ToggleTag) {
      if (activeTags.contains(event.tag)) {
        activeTags.remove(event.tag);
      } else {
        activeTags.add(event.tag);
      }
      yield TagLoadedState();
    }
  }
}
