import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UploadManagerEvent extends Equatable {
  UploadManagerEvent([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class UploadFinished extends UploadManagerEvent {
  UploadFinished({@required this.fileUrl}) : super(<dynamic>[fileUrl]);
  final String fileUrl;
}

class Upload extends UploadManagerEvent {
  Upload({@required this.file}) : super(<dynamic>[file]);
  final File file;
  @override
  String toString() => 'Upload: ' + file.path;
}

class Cancel extends UploadManagerEvent {
  @override
  String toString() => 'Cancel upload';
}

class Delete extends UploadManagerEvent {
  @override
  String toString() => 'Delete';
}

class UpdateProgress extends UploadManagerEvent {
  UpdateProgress({@required this.bytesTransferred, @required this.totalByteCount}) : super(<dynamic>[bytesTransferred, totalByteCount]);
  final int bytesTransferred;
  final int totalByteCount;

  @override
  String toString() => 'Update Progress: ' + (bytesTransferred / totalByteCount).toString();
}
