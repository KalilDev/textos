import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AtomicOperation { add, remove }

class FavoritesHelper {
  FavoritesHelper({@required this.userId});

  final String userId;

  final Firestore db = Firestore.instance;
  final CollectionReference favoritesCollection =
      Firestore.instance.collection('favorites');
  final DocumentReference statsDocument =
      Firestore.instance.collection('favorites').document('_stats_');

  Future<DocumentSnapshot> get userDocumentSnapshot async {
    final QuerySnapshot queryResult = await favoritesCollection
        .where('userId', isEqualTo: userId)
        .getDocuments();
    final List<DocumentSnapshot> snapshots = queryResult.documents;
    if (snapshots.isEmpty) {
      DocumentReference document;
      document = await favoritesCollection.add(<String, dynamic>{
        'userId': userId,
        'textReferences': <DocumentReference>[],
        'textTitles': <String>[]
      });
      return await document.get();
    } else {
      return snapshots[0];
    }
  }

  Future<DocumentReference> get userDocument async {
    final DocumentSnapshot snap = await userDocumentSnapshot;
    return snap.reference;
  }

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

  Future<void> syncDatabase(List<String> favorites) async {
    if (userId != null && isInDebugMode == false) {
      final DocumentSnapshot snapshot = await userDocumentSnapshot;
      final DocumentReference document = await userDocument;

      final List<dynamic> remoteReferences = snapshot.data['textReferences'];

      final List<DocumentReference> localReferences = <DocumentReference>[];
      final List<String> localTitles = <String>[];
      for (String favorite in favorites) {
        final String title = favorite.split(';')[0];
        final DocumentReference reference = db.document(favorite.split(';')[1]);
        localReferences.add(reference);
        localTitles.add(title);
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
          'textReferences': localReferences,
          'textTitles': localTitles
        });
        delta.forEach((String docPath, int delta) => batch.updateData(
            statsDocument,
            <String, dynamic>{docPath: FieldValue.increment(delta)}));
        await batch.commit();
      }
    }
  }

  Future<void> atomicOperation(String favorite,
      {AtomicOperation operation}) async {
    if (userId != null && isInDebugMode == false) {
      final String title = favorite.split(';')[0];
      final DocumentReference reference = db.document(favorite.split(';')[1]);
      final String path = reference.path.replaceAll('/', '_');
      final DocumentSnapshot snapshot = await userDocumentSnapshot;
      final DocumentReference document = await userDocument;

      final List<dynamic> remoteReferences = snapshot.data['textReferences'];
      final List<dynamic> remoteTitles = snapshot.data['textTitles'];

      final Set<DocumentReference> localReferences =
          Set<DocumentReference>.from(remoteReferences);
      final Set<String> localTitles = Set<String>.from(remoteTitles);

      int incValue;
      if (operation == AtomicOperation.add) {
        localTitles.add(title);
        localReferences.add(reference);
        incValue = 1;
      } else if (operation == AtomicOperation.remove) {
        localTitles.remove(title);
        localReferences.remove(reference);
        incValue = -1;
      }

      final WriteBatch batch = db.batch();
      batch.updateData(document, <String, dynamic>{
        'textReferences': localReferences.toList(),
        'textTitles': localTitles.toList()
      });
      batch.updateData(statsDocument,
          <String, dynamic>{path: FieldValue.increment(incValue)});
      batch.commit();
    }
  }
}
