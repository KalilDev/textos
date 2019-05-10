import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesHelper {
  final String userId;

  FavoritesHelper({@required this.userId});

  final Firestore db = Firestore.instance;
  final CollectionReference favoritesCollection =
      Firestore.instance.collection('favorites');
  final DocumentReference statsDocument =
      Firestore.instance.collection('favorites').document('_stats_');

  Future<DocumentSnapshot> get userDocumentSnapshot async {
    final queryResult = await favoritesCollection
        .where('userId', isEqualTo: userId)
        .getDocuments();
    List snapshots = queryResult.documents;
    if (snapshots.length == 0) {
      DocumentReference document;
      document = await favoritesCollection.add({
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
    DocumentSnapshot snap = await userDocumentSnapshot;
    return snap.reference;
  }

  Map<String, int> _getDelta(
      List<DocumentReference> localReferences, List remoteReferences) {
    // Wont detect duplicated documents
    localReferences.sort((ref1, ref2) => ref1.path.compareTo(ref2.path));
    remoteReferences.sort((ref1, ref2) => ref1.path.compareTo(ref2.path));

    Map<String, int> delta = {};
    localReferences.forEach((ref) {
      if (!remoteReferences.contains(ref)) {
        String path = ref.path;
        delta[path.replaceAll('/', '_')] = 1;
      }
    });
    remoteReferences.forEach((ref) {
      if (!localReferences.contains(ref)) {
        String path = ref.path;
        delta[path.replaceAll('/', '_')] = -1;
      }
    });
    return delta;
  }

  // Check if we are running debug mode
  bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  void syncDatabase(Set<String> favorites) async {
    if (userId != null || isInDebugMode == true) {
      DocumentSnapshot snapshot = await userDocumentSnapshot;
      DocumentReference document = await userDocument;

      List remoteReferences = snapshot.data['textReferences'];

      List<DocumentReference> localReferences = [];
      List<String> localTitles = [];
      favorites.forEach((favorite) {
        final title = favorite.split(';')[0];
        final reference = db.document(favorite.split(';')[1]);
        localReferences.add(reference);
        localTitles.add(title);
      });

      final delta = _getDelta(localReferences, remoteReferences);

      // If there are changes OR if there are duplicate entries on remote
      // references AKA if the user tried to fuck the favorites counter by
      // pressing it many times in a short timespan.
      // NEVER TRUST USERS. NEVER.
      if (delta.length > 0 ||
          remoteReferences.length != remoteReferences
              .toSet()
              .length) {
        final batch = db.batch();
        batch.updateData(document,
            {'textReferences': localReferences, 'textTitles': localTitles});
        delta.forEach((docPath, delta) =>
            batch
                .updateData(
                statsDocument, {docPath: FieldValue.increment(delta)}));
        await batch.commit();
      }
    }
  }

  void addFavorite(String favorite) async {
    if (userId != null || isInDebugMode == true) {
      final title = favorite.split(';')[0];
      final reference = db.document(favorite.split(';')[1]);
      final path = reference.path.replaceAll('/', '_');
      final snapshot = await userDocumentSnapshot;
      final document = await userDocument;

      final List remoteReferences = snapshot.data['textReferences'];
      final List remoteTitles = snapshot.data['textTitles'];

      List localReferences = List.from(remoteReferences, growable: true);
      List localTitles = List.from(remoteTitles, growable: true);

      localTitles.add(title);
      localReferences.add(reference);
      final batch = db.batch();
      batch.updateData(document,
          {'textReferences': localReferences, 'textTitles': localTitles});
      batch.updateData(statsDocument, {path: FieldValue.increment(1)});
      batch.commit();
    }
  }

  void removeFavorite(String favorite) async {
    if (userId != null || isInDebugMode == true) {
      final title = favorite.split(';')[0];
      final reference = db.document(favorite.split(';')[1]);
      final path = reference.path.replaceAll('/', '_');
      final snapshot = await userDocumentSnapshot;
      final document = await userDocument;

      final List remoteReferences = snapshot.data['textReferences'];
      final List remoteTitles = snapshot.data['textTitles'];

      List localReferences = List.from(remoteReferences, growable: true);
      List localTitles = List.from(remoteTitles, growable: true);

      localTitles.remove(title);
      localReferences.remove(reference);
      final batch = db.batch();
      batch.updateData(document,
          {'textReferences': localReferences, 'textTitles': localTitles});
      batch.updateData(statsDocument, {path: FieldValue.increment(-1)});
      batch.commit();
    }
  }
}
