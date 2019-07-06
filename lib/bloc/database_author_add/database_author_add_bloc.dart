import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './bloc.dart';
import '../../model/author.dart';

class DatabaseAuthorAddBloc
    extends Bloc<DatabaseAuthorAddEvent, DatabaseAuthorAddState> {
  DatabaseAuthorAddBloc({Author author}) {
    tags = author?.tags;
    _initialAuthor = author;
    authorID = author?.authorID;
    titleManager =
        TitleManagerBloc(authorName: author?.authorName, title: author?.title);
  }
  String get authorName => titleManager.authorName;
  String get title => titleManager.title;
  List<String> tags;
  String authorID;
  TitleManagerBloc titleManager;

  Author _initialAuthor;
  @override
  DatabaseAuthorAddState get initialState {
    if (_initialAuthor != null) {
      return ModifyAuthorState();
    } else {
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        dispatch(AuthorIDLoaded(authorID: user.uid));
      });
      return AddAuthorLoadingState();
    }
  }

  DatabaseAuthorAddState _updateState() {
    return _initialAuthor != null ? ModifyAuthorState() : AddAuthorState();
  }

  Author get author => Author(
      authorName: authorName, title: title, tags: tags, authorID: authorID);

  Future<void> _upload() async {
    final DocumentReference document =
        Firestore.instance.collection('texts').document(authorID);
    final DocumentSnapshot snap = await document.get();
    if (!snap.exists) {
      await document.setData(<String, dynamic>{
        'authorName': authorName,
        'title': title + ' ',
        'tags': tags,
        'visible': false
      });
    } else {
      await document.updateData(<String, dynamic>{
        'authorName': authorName,
        'title': title + ' ',
        'tags': tags,
        'visible': false
      });
    }
    dispatch(UploadFinished());
  }

  @override
  Stream<DatabaseAuthorAddState> mapEventToState(
    DatabaseAuthorAddEvent event,
  ) async* {
    if (event is AuthorIDLoaded) {
      authorID = event.authorID;
      yield AddAuthorState();
    }

    if (event is AuthorTitleUpdate) {
      titleManager.dispatch(UpdateTitle(title: event.title));
    }

    if (event is AuthorNameUpdate) {
      titleManager.dispatch(UpdateAuthorName(authorName: event.authorName));
    }

    if (event is AuthorTagAdd) {
      tags.add(event.tag);
      yield _updateState();
    }

    if (event is AuthorTagRemove) {
      tags.removeAt(event.tag);
      yield _updateState();
    }

    if (event is AuthorTagModify) {
      tags[event.index] = event.tag;
      yield _updateState();
    }

    if (event is AuthorUpload) {
      _upload();
    }

    if (event is UploadFinished) {
      
    }
  }
}
