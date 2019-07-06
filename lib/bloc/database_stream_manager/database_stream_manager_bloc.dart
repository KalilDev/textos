import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:textos/model/author.dart';

import './bloc.dart';

class DatabaseStreamManagerBloc
    extends Bloc<DatabaseStreamManagerEvent, DatabaseStreamManagerState> {
  Stream<Iterable<Author>> authorStream;
  String userID;

  @override
  DatabaseStreamManagerState get initialState {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      StreamSubscription<Iterable<Author>> subscription;
      userID = user.uid;
      authorStream = Firestore.instance
          .collection('texts')
          .snapshots()
          .map<Iterable<Author>>((QuerySnapshot list) => list.documents
              .map<Author>((DocumentSnapshot snap) => Author.fromFirestore(
                  snap.data,
                  authorID: snap.documentID,
                  currentUID: userID)));
      subscription = authorStream.listen((Iterable<Author> data) {
        if (data.isNotEmpty) {
          subscription.cancel();
          if (userID != null)
            dispatch(LoadedAuthors());
        }
      });
    });
    return LoadingAuthorsStream();
  }

  @override
  Stream<DatabaseStreamManagerState> mapEventToState(
    DatabaseStreamManagerEvent event,
  ) async* {
    if (event is LoadedAuthors) {
      yield LoadedAuthorsStream();
    }
  }
}
