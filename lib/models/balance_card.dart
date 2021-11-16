import 'package:imes/models/pageable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_card.g.dart';

@JsonSerializable()
class BalanceCardResponse {
  const BalanceCardResponse({this.page});

  final BalanceCardPage page;

  static const fromJsonFactory = _$BalanceCardResponseFromJson;

  factory BalanceCardResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceCardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceCardResponseToJson(this);
}

@JsonSerializable()
class BalanceCardPage extends Pageable {
  List<BalanceCard> data;

  BalanceCardPage({
    int currentPage,
    this.data,
    int from,
    int to,
    int total,
    int lastPage,
    // int perPage,
  }) : super(
          currentPage: currentPage,
          from: from,
          to: to,
          total: total,
          lastPage: lastPage,
          //  perPage: perPage,
        );

  factory BalanceCardPage.fromJson(Map<String, dynamic> json) =>
      _$BalanceCardPageFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BalanceCardPageToJson(this);
}

@JsonSerializable()
class BalanceCardItemResponse {
  const BalanceCardItemResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  final int statusCode;
  final String message;
  final BalanceCard data;

  static const fromJsonFactory = _$BalanceCardItemResponseFromJson;

  factory BalanceCardItemResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceCardItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceCardItemResponseToJson(this);
}

@JsonSerializable()
class BalanceCard {
  const BalanceCard({
    this.id,
    this.cardId,
    this.name,
    this.shortDescription,
    this.description,
    this.categoryId,
    this.isActive,
    this.cost,
    this.cover,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int cardId;
  final String name;
  final String shortDescription;
  final String description;
  final String categoryId;
  @JsonKey(
    name: 'is_active',
    fromJson: _boolFromInt,
    toJson: _boolToInt,
  )
  final bool isActive;
  final int cost;
  final String cover;
  final DateTime createdAt;
  final DateTime updatedAt;

  static bool _boolFromInt(int value) => value == 1;

  static int _boolToInt(bool value) => value ? 1 : 0;

  factory BalanceCard.fromJson(Map<String, dynamic> json) =>
      _$BalanceCardFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceCardToJson(this);
}
