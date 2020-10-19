import 'package:json_annotation/json_annotation.dart';

part 'withdraw_history.g.dart';

@JsonSerializable()
class WithdrawHistory {
  final num id;
  @JsonKey(name: 'user_id')
  final num userId;
  final int total;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime deletedAt;
  final String type;
  final String comment;

  WithdrawHistory({
    this.id,
    this.userId,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.type,
    this.comment,
  });

  factory WithdrawHistory.fromJson(Map<String, dynamic> json) =>
      _$WithdrawHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawHistoryToJson(this);
}
