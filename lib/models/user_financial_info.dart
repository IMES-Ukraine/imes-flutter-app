import 'package:json_annotation/json_annotation.dart';

part 'user_financial_info.g.dart';

@JsonSerializable()
class UserFinancialInfo {
  final String card;

  UserFinancialInfo({this.card});

  factory UserFinancialInfo.fromJson(Map<String, dynamic> json) => _$UserFinancialInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserFinancialInfoToJson(this);
}
