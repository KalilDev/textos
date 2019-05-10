import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textos/Src/Constants.dart';
import 'package:textos/Src/Controllers/TagPageController.dart';

class QueryController {
  Firestore db = Firestore.instance;
  TagPageController tagPageController;
  Query query;
  String tag;
  Stream dataStream;
  Stream favoritesStream;

  String get authorCollection => tagPageController.authorCollection;

  set authorCollection(String collection) =>
      tagPageController.authorCollection = collection;

  QueryController({this.tagPageController}) {
    query = db.collection(authorCollection);
    updateQuery();
    favoritesStream = db
        .collection('favorites')
        .document('_stats_')
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.data);
  }

  set queryParameters(MapEntry<String, String> queryParameters) {
    //print(queryParameters);
    if (queryParameters.key == 'collection') {
      authorCollection = queryParameters.value;
      tag = null;
      //print('newCollection: ' + authorCollection);
    } else if (queryParameters.key == 'tag') {
      if (queryParameters.value != Constants.textAllTag) {
        tag = queryParameters.value;
        query =
            db.collection(authorCollection).where('tags', arrayContains: tag);
        //print('newTag: ' + tag);
        return updateDataStream();
      } else {
        tag = null;
        //print('allTags');
      }
    } else {
      //print('allFromCollection: ' + authorCollection);
    }
    query = db.collection(authorCollection);
    updateDataStream();
  }

  void updateQuery() {
    queryParameters = MapEntry(null, null);
  }

  void updateDataStream() {
    dataStream = query.snapshots().map((list) => list.documents.map((doc) {
          final Map data = doc.data;
          data['path'] = doc.reference.path;
          data['favoriteCount'] = 0;
          return data;
        }));
  }
}
