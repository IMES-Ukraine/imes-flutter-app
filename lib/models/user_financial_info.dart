import 'package:json_annotation/json_annotation.dart';

part 'user_financial_info.g.dart';

@JsonSerializable()
class UserFinancialInfo {
  final String card;
  final String exp;
  final String ccv;

  UserFinancialInfo({
    this.card,
    this.exp,
    this.ccv,
  });

  factory UserFinancialInfo.fromJson(Map<String, dynamic> json) => _$UserFinancialInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserFinancialInfoToJson(this);
}
