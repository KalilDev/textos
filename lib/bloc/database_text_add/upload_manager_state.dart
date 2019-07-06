import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UploadManagerState extends Equatable {
  UploadManagerState([List<dynamic> props = const <dynamic>[]]) : super(props);
}

class Uploading extends UploadManagerState {
  Uploading({@required this.totalByteCount, @required this.bytesTransferred})
      : assert(bytesTransferred != null),
        assert(totalByteCount != null),
        super(<int>[totalByteCount, bytesTransferred]);
  final int totalByteCount;
  final int bytesTransferred;
}

class Uploaded extends UploadManagerState {
  Uploaded({@required this.fileUrl})
      : assert (fileUrl != null),
        super(<String>[fileUrl]);
  final String fileUrl;
}

class ToUpload extends UploadManagerState {}