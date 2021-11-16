import 'package:imes/helpers/bool_mapper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_card_history.g.dart';

@JsonSerializable()
class BalanceCardHistoryItem {
  const BalanceCardHistoryItem({
    this.id,
    this.userId,
    this.cardId,
    this.isActive,
    this.cost,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final int cardId;
  @JsonKey(
    name: 'is_active',
    fromJson: boolFromInt,
    toJson: boolToInt,
  )
  final bool isActive;
  final String cost;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory BalanceCardHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$BalanceCardHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceCardHistoryItemToJson(this);
}
