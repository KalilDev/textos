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

  String get authorCollection => tagPageController.authorCollection;

  set authorCollection(String collection) =>
      tagPageController.authorCollection = collection;

  QueryController({this.tagPageController}) {
    query = db.collection(authorCollection);
    updateQuery();
  }

  set queryParameters(MapEntry<String, String> todo) {
    print(todo);
    if (todo.key == 'collection') {
      authorCollection = todo.value;
      tag = null;
      print('newCollection: ' + authorCollection);
    } else if (todo.key == 'tag') {
      if (todo.value != Constants.textAllTag) {
        tag = todo.value;
        query =
            db.collection(authorCollection).where('tags', arrayContains: tag);
        print('newTag: ' + tag);
        return updateDataStream();
      } else {
        tag = null;
        print('allTags');
      }
    } else {
      print('allFromCollection: ' + authorCollection);
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
          data['id'] = doc.documentID;
          data['localFavorites'] = 0;
          return data;
        }));
  }
}
