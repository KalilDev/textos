import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:textos/bloc/upload_manager/bloc.dart';

class UploadManagerBloc extends Bloc<UploadManagerEvent, UploadManagerState> {
  UploadManagerBloc({this.fileUrl});
  String fileUrl;
  StreamSubscription<StorageTaskEvent> _storageTaskSubscription;
  StorageUploadTask _uploadTask;

  @override
  UploadManagerState get initialState => fileUrl == null ? ToUpload() : Uploaded(fileUrl: fileUrl);

  @override
  Stream<UploadManagerState> mapEventToState(
    UploadManagerEvent event,
  ) async* {
    if (event is Upload) {
      final String fileName =
      event.file.path.split('/')[event.file.path
          .split('/')
          .length - 1];
      _uploadTask = FirebaseStorage().ref().child(fileName).putFile(event.file);
      _storageTaskSubscription?.cancel();
      _storageTaskSubscription = _uploadTask.events.listen((StorageTaskEvent event) async {
        switch (event.type) {
          case StorageTaskEventType.success: {
            final String url = await FirebaseStorage()
                .ref()
                .child(event.snapshot.storageMetadata.path)
                .getDownloadURL();
            dispatch(UploadFinished(fileUrl: url));
            _storageTaskSubscription.cancel();
            _uploadTask = null;
          } break;
          case StorageTaskEventType.progress: {
            dispatch(UpdateProgress(bytesTransferred: event.snapshot.bytesTransferred, totalByteCount: event.snapshot.totalByteCount));
          } break;
          case StorageTaskEventType.pause: {
            // To implement
          } break;
          case StorageTaskEventType.resume: {
            //To implement
          } break;
          case StorageTaskEventType.failure: {
            _storageTaskSubscription?.cancel();
            _uploadTask = null;
          } break;
        }
      });
    }

    if (event is Cancel) {
      _storageTaskSubscription?.cancel();
      _uploadTask?.cancel();
      if (fileUrl == null)
        yield ToUpload();
      else
        yield Uploaded(fileUrl: fileUrl);

    }

    if (event is Delete) {
      fileUrl = null;
      yield ToUpload();
    }

    if (event is UploadFinished) {
      fileUrl = event.fileUrl;
      yield Uploaded(fileUrl: fileUrl);
    }

    if (event is UpdateProgress) {
      yield Uploading(totalByteCount: event.totalByteCount, bytesTransferred: event.bytesTransferred);
    }

  }
}
