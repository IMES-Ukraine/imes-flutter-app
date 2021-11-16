import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imes/models/user_basic_info.dart';
import 'package:imes/models/user_financial_info.dart';
import 'package:imes/models/user_special_info.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({
    num id,
    String name,
    String surname,
    String email,
    bool isActivated,
    String phone,
    String city,
    String work,
    int balance,
    String firebaseToken,
    String messagingToken,
    UserBasicInfo basicInformation,
    UserSpecializedInfo specializedInformation,
    UserFinancialInfo financialInformation,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
