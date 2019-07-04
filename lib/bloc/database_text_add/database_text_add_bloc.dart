import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../model/content.dart';
import '../tag_manager/bloc.dart';
import '../upload_manager/bloc.dart';
import 'bloc.dart';

class DatabaseTextAddBloc
    extends Bloc<DatabaseTextAddEvent, DatabaseTextAddState> {
  DatabaseTextAddBloc.fromContent({@required Content content}) {
    text = content?.text?.replaceAll('^NL', '\n');
    title = content?.title;
    date = content?.rawDate;
    tagManager = TagManagerBloc(activeTags: content?.tags);
    musicUploadManager = UploadManagerBloc(fileUrl: content?.music);
    photoUploadManager = UploadManagerBloc(fileUrl: content?.rawImgUrl);
    _initialContent = content;
  }

  Content get content => Content(
      title: title,
      rawDate: date,
      rawImgUrl: photoUrl,
      text: text?.replaceAll('\n', '^NL'),
      music: musicUrl,
      tags: tagManager.activeTags);

  String get musicUrl => musicUploadManager.fileUrl;
  String get photoUrl => photoUploadManager.fileUrl;
  List<String> get tags => tagManager.activeTags;
  String text;
  String title;
  String date;
  TagManagerBloc tagManager;
  UploadManagerBloc musicUploadManager;
  UploadManagerBloc photoUploadManager;
  Content _initialContent;

  bool get canPop => true; // ToImplement

  @override
  DatabaseTextAddState get initialState =>
      _initialContent == null ? TextCreateState() : TextEditState();

  Future<void> upload() async {
    if (_initialContent?.textPath != null) {
      Firestore.instance
          .document(_initialContent.textPath)
          .updateData(content.toData());
    } else {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Firestore.instance
          .collection('texts')
          .document(user.uid)
          .collection('documents')
          .add(content.toData());
    }
  }

  Future<void> delete() async => Firestore.instance.document(_initialContent.textPath).delete();

  @override
  Stream<DatabaseTextAddState> mapEventToState(
    DatabaseTextAddEvent event,
  ) async* {
    if (event is DateChanged) {
      date = event.date;
    }

    if (event is TextChanged) {
      text = event.text;
    }

    if (event is TitleChanged) {
      title = event.title;
    }
  }
}
