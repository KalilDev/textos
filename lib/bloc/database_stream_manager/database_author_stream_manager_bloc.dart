import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textos/model/content.dart';

import './bloc.dart';

class DatabaseAuthorStreamManagerBloc extends Bloc<
    DatabaseAuthorStreamManagerEvent, DatabaseAuthorStreamManagerState> {
  DatabaseAuthorStreamManagerBloc(this.authorID, {this.userID, String initialTag})
      : assert(authorID != null),
        _initialTag = initialTag,
        textsCollection = Firestore.instance
            .document('texts/' + authorID)
            .collection('documents');

  final String authorID;
  final String userID;
  final CollectionReference textsCollection;
  Map<String, int> _favoritesData;
  String _initialTag;
  Stream<Iterable<Content>> textsStream;
  bool get canEdit => authorID == userID;

  set favoritesData(Map<String, int> data) {
    /*data ??= <String, int>{};
    Map<String, int> toAdd = <String, int>{};
    data.forEach((String key, int value) {
      if (key.contains(authorID)) {
        toAdd[key.split('_')[key.split('_').length-1]] = value;
      }
    });
    textsStream = _textsStream.map((Iterable<Content> contents) => contents.map((Content content) {
      final int toAddVal = toAdd[content.textPath.replaceAll('/', '_')];
      if (toAddVal != null)
        return content.copyWith(favoriteCount: toAddVal);
      return content;
    }));*/
    _favoritesData = data;
  }

  @override
  DatabaseAuthorStreamManagerState get initialState {
    _updateStream(tag: _initialTag);
    return LoadingTextsStream(tag: _initialTag);
  }

  void _updateStream({String tag}) {
    if (true) {
      textsStream = textsCollection.orderBy('date', descending: true).snapshots().map<Iterable<Content>>((QuerySnapshot querySnap) =>
          querySnap.documents.map<Content>(
                  (DocumentSnapshot snap) => Content.fromFirestore(snap.data, authorID: authorID)));
    } else {
      textsStream = textsCollection.where('tags', arrayContains: tag).snapshots().map<Iterable<Content>>((QuerySnapshot querySnap) {
          final List<Content> intermediate = querySnap.documents.map<Content>(
                  (DocumentSnapshot snap) => Content.fromFirestore(snap.data, authorID: authorID)).toList();
      intermediate.sort((Content content1, Content content2) => int.parse(content1.rawDate).compareTo(int.parse(content2.rawDate)));
      });
    }
    StreamSubscription<Iterable<Content>> subscription;
    subscription = textsStream.listen((Iterable<Content> content) {
      if (content != null) {
        dispatch(FinishedLoading(tag: tag));
        subscription.cancel();
      }
    });
    favoritesData = _favoritesData;
  }

  @override
  Stream<DatabaseAuthorStreamManagerState> mapEventToState(
    DatabaseAuthorStreamManagerEvent event,
  ) async* {
    if (event is FinishedLoading) {
      yield LoadedTextsStream(tag: event.tag);
    }
  }
}
