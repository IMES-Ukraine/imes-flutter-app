import 'package:imes/models/user_basic_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final num id;
  final String name;
  final String surname;
  final String username;
  final String email;
  @JsonKey(name: 'is_activated')
  final bool isActivated;
  final String phone;
  final String city;
  final String work;
  final int balance;
  @JsonKey(name: 'firebase_token')
  final String firebaseToken;
  @JsonKey(name: 'messaging_token')
  final String messagingToken;
  @JsonKey(name: 'basic_information')
  final UserBasicInfo basicInfo;

  User({
    this.id,
    this.name,
    this.surname,
    this.username,
    this.email,
    this.isActivated,
    this.phone,
    this.city,
    this.work,
    this.balance,
    this.firebaseToken,
    this.messagingToken,
    this.basicInfo,
  });

  User copyWith({
    final num id,
    final String name,
    final String surname,
    final String username,
    final String email,
    final bool isActivated,
    final String phone,
    final String city,
    final String work,
    final int balance,
    final String firebaseToken,
    final String messagingToken,
    final UserBasicInfo basicInfo,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      username: username ?? this.username,
      email: email ?? this.email,
      isActivated: isActivated ?? this.isActivated,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      work: work ?? this.work,
      balance: balance ?? this.balance,
      firebaseToken: firebaseToken ?? this.firebaseToken,
      messagingToken: messagingToken ?? this.messagingToken,
      basicInfo: basicInfo ?? this.basicInfo,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
