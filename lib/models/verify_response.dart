import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_response.freezed.dart';
part 'verify_response.g.dart';

@freezed
abstract class VerifyResponse with _$VerifyResponse {
  factory VerifyResponse({String token}) = _VerifyResponse;

  static const fromJsonFactory = _$VerifyResponseFromJson;

  factory VerifyResponse.fromJson(Map<String, dynamic> json) => _$VerifyResponseFromJson(json);
}
