import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/favorite.dart';

enum AtomicOperation { add, remove }

class FavoritesHelper {
  FavoritesHelper({@required this.userId});

  final String userId;

  final Firestore db = Firestore.instance;
  final CollectionReference favoritesCollection =
      Firestore.instance.collection('users');
  final DocumentReference statsDocument =
      Firestore.instance.collection('users').document('_favorites_');

  Map<String, int> _getDelta(
      List<DocumentReference> localReferences, List<dynamic> remoteReferences) {
    // Wont detect duplicated documents
    localReferences.sort((DocumentReference ref1, DocumentReference ref2) =>
        ref1.path.compareTo(ref2.path));
    remoteReferences
        .sort((dynamic ref1, dynamic ref2) => ref1.path.compareTo(ref2.path));

    final Map<String, int> delta = <String, int>{};
    for (DocumentReference ref in localReferences) {
      if (!remoteReferences.contains(ref)) {
        final String path = ref.path;
        delta[path.replaceAll('/', '_')] = 1;
      }
    }
    for (DocumentReference ref in remoteReferences) {
      if (!localReferences.contains(ref)) {
        final String path = ref.path;
        delta[path.replaceAll('/', '_')] = -1;
      }
    }
    return delta;
  }

  // Check if we are running debug mode
  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  Future<void> syncDatabase(Set<Favorite> favorites) async {
    if (userId != null && isInDebugMode == false) {
      final DocumentReference document = favoritesCollection.document(userId);
      final DocumentSnapshot snapshot = await document.get();
      List<dynamic> remoteReferences;
      if (snapshot?.data?.isEmpty ?? true) {
        document.setData(<String, dynamic>{'favoriteReferences': <dynamic>[]});
        remoteReferences = <dynamic>[];
      } else {
        remoteReferences = snapshot?.data['favoriteReferences'] ?? <dynamic>[];
      }

      final List<DocumentReference> localReferences = <DocumentReference>[];
      for (Favorite favorite in favorites) {
        final DocumentReference reference = db.document(favorite.textPath);
        localReferences.add(reference);
      }

      final Map<String, int> delta =
          _getDelta(localReferences, remoteReferences);

      // If there are changes OR if there are duplicate entries on remote
      // references AKA if the user tried to fuck the favorites counter by
      // pressing it many times in a short timespan.
      // NEVER TRUST USERS. NEVER.
      if (delta.isNotEmpty ||
          remoteReferences.length != remoteReferences.toSet().length) {
        final WriteBatch batch = db.batch();
        batch.updateData(document, <String, dynamic>{
          'favoriteReferences': localReferences,
        });
        delta.forEach((String docPath, int delta) => batch.updateData(
            statsDocument,
            <String, dynamic>{docPath: FieldValue.increment(delta)}));
        await batch.commit();
      }
    }
  }

  Future<void> atomicOperation(
      {String title, String path, AtomicOperation operation}) async {
    if (userId != null && isInDebugMode == false) {
      final DocumentReference reference = db.document(path);
      final DocumentReference document = favoritesCollection.document(userId);
      final DocumentSnapshot snapshot = await document.get();

      final List<dynamic> remoteReferences = snapshot.data['favoriteReferences'];

      final Set<DocumentReference> localReferences =
          Set<DocumentReference>.from(remoteReferences);

      int incValue;
      if (operation == AtomicOperation.add) {
        localReferences.add(reference);
        incValue = 1;
      } else if (operation == AtomicOperation.remove) {
        localReferences.remove(reference);
        incValue = -1;
      }

      final WriteBatch batch = db.batch();
      batch.updateData(document, <String, dynamic>{
        'favoriteReferences': localReferences.toList()
      });
      batch.updateData(statsDocument, <String, dynamic>{
        path.replaceAll('/', '_'): FieldValue.increment(incValue)
      });
      batch.commit();
    }
  }
}
