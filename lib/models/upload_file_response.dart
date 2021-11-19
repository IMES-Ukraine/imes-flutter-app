import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imes/models/cover_image.dart';

part 'upload_file_response.freezed.dart';
part 'upload_file_response.g.dart';

@freezed
abstract class UploadFileResponse with _$UploadFileResponse {
  factory UploadFileResponse({CoverImage data}) = _UploadFileResponse;

  static const fromJsonFactory = _$UploadFileResponseFromJson;

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadFileResponseFromJson(json);
}
