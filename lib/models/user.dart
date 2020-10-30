import 'package:imes/models/user_basic_info.dart';
import 'package:imes/models/user_financial_info.dart';
import 'package:imes/models/user_special_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

  // final num id;
  // final String name;
  // final String surname;
  // final String username;
  // final String email;
  // @JsonKey(name: 'is_activated')
  // final bool isActivated;
  // final String phone;
  // final String city;
  // final String work;
  // final int balance;
  // @JsonKey(name: 'firebase_token')
  // final String firebaseToken;
  // @JsonKey(name: 'messaging_token')
  // final String messagingToken;
  // @JsonKey(name: 'basic_information')
  // final UserBasicInfo basicInfo;
  // @JsonKey(name: 'specialized_information')
  // final UserSpecializedInfo specialInfo;
  // @JsonKey(name: 'financial_information')
  // final UserFinancialInfo financialInfo;

  // User({
  //   this.id,
  //   this.name,
  //   this.surname,
  //   this.username,
  //   this.email,
  //   this.isActivated,
  //   this.phone,
  //   this.city,
  //   this.work,
  //   this.balance,
  //   this.firebaseToken,
  //   this.messagingToken,
  //   this.basicInfo,
  //   this.specialInfo,
  //   this.financialInfo,
  // });
  // User copyWith({
  //   final num id,
  //   final String name,
  //   final String surname,
  //   final String username,
  //   final String email,
  //   final bool isActivated,
  //   final String phone,
  //   final String city,
  //   final String work,
  //   final int balance,
  //   final String firebaseToken,
  //   final String messagingToken,
  //   final UserBasicInfo basicInfo,
  //   final UserSpecializedInfo specialInfo,
  //   final UserFinancialInfo financialInfo,
  // }) {
  //   return User(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     surname: surname ?? this.surname,
  //     username: username ?? this.username,
  //     email: email ?? this.email,
  //     isActivated: isActivated ?? this.isActivated,
  //     phone: phone ?? this.phone,
  //     city: city ?? this.city,
  //     work: work ?? this.work,
  //     balance: balance ?? this.balance,
  //     firebaseToken: firebaseToken ?? this.firebaseToken,
  //     messagingToken: messagingToken ?? this.messagingToken,
  //     basicInfo: basicInfo ?? this.basicInfo,
  //     specialInfo: specialInfo ?? this.specialInfo,
  //     financialInfo: financialInfo ?? this.financialInfo,
  //   );
  // }

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Map<String, dynamic> toJson() => _$UserToJson(this);
}
