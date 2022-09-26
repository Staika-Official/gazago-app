import 'package:json_annotation/json_annotation.dart';

part 'user_account_model.g.dart';

@JsonSerializable()
class UserAccountModel {
  int id;
  String login;
  String email;
  String nickname;
  String profileImageUrl;
  String? phone;
  String userCode;
  String provider;
  bool marketingChecked;
  bool alarmTransaction;
  bool alarmEvent;
  bool activated;
  String? createdDate;
  List<String> authorities;
  String? terminationDate;

  UserAccountModel({
    required this.id,
    required this.login,
    required this.email,
    required this.nickname,
    required this.profileImageUrl,
    this.phone,
    required this.userCode,
    required this.provider,
    required this.marketingChecked,
    required this.alarmTransaction,
    required this.alarmEvent,
    required this.activated,
    this.createdDate,
    required this.authorities,
    this.terminationDate,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) => _$UserAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountModelToJson(this);
}
