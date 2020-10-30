import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_financial_info.freezed.dart';
part 'user_financial_info.g.dart';

@freezed
abstract class UserFinancialInfo with _$UserFinancialInfo {
  factory UserFinancialInfo({
    String card,
    String exp,
    String ccv,
  }) = _UserFinancialInfo;

  factory UserFinancialInfo.fromJson(Map<String, dynamic> json) => _$UserFinancialInfoFromJson(json);
  // Map<String, dynamic> toJson() => _$UserFinancialInfoToJson(this);
}
