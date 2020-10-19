import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'is_activated')
  final bool isActivated;
  // @JsonKey(name: 'activated_at')
  // final DateTime activatedAt;
  // @JsonKey(name: 'last_login')
  // final DateTime lastLogin;
  // @JsonKey(name: 'created_at')
  // final DateTime createdAt;
  // @JsonKey(name: 'updated_at')
  // final DateTime updatedAt;
  final String username;
  final String surname;
  // @JsonKey(name: 'deleted_at')
  // final DateTime deletedAt;
  // @JsonKey(name: 'last_seen')
  // final DateTime lastSeen;
  final String phone;
  final String city;
  final String work;
  final int balance;
  @JsonKey(name: 'firebase_token')
  final String firebaseToken;

  User({
    this.id,
    this.name,
    this.email,
    this.isActivated,
    // this.activatedAt,
    // this.lastLogin,
    // this.createdAt,
    // this.updatedAt,
    this.username,
    this.surname,
    // this.deletedAt,
    // this.lastSeen,
    this.phone,
    this.city,
    this.work,
    this.balance,
    this.firebaseToken,
  });

  User copyWith({
    final num id,
    final String name,
    final String email,
    final bool isActivated,
    final DateTime activatedAt,
    final DateTime lastLogin,
    final DateTime createdAt,
    final DateTime updatedAt,
    final String username,
    final String surname,
    final DateTime deletedAt,
    final DateTime lastSeen,
    final String phone,
    final String city,
    final String work,
    final int balance,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActivated: isActivated ?? this.isActivated,
      // lastLogin: lastLogin ?? this.lastLogin,
      // createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      surname: surname ?? this.surname,
      // deletedAt: deletedAt ?? this.deletedAt,
      // lastSeen: lastSeen ?? this.lastSeen,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      work: work ?? this.work,
      balance: balance ?? this.balance,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
