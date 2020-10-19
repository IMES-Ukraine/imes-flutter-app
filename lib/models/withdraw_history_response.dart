import 'package:json_annotation/json_annotation.dart';
import 'withdraw_page.dart';

part 'withdraw_history_response.g.dart';

@JsonSerializable()
class WithdrawHistoryResponse {
  @JsonKey(name: 'status_code')
  final int statusCode;
  final String message;
  final WithdrawPage data;

  WithdrawHistoryResponse({this.statusCode, this.message, this.data});

  static const fromJsonFactory = _$WithdrawHistoryResponseFromJson;

  factory WithdrawHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawHistoryResponseToJson(this);
}
