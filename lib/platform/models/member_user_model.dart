import 'package:json_annotation/json_annotation.dart';

part 'member_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberUserModel {
  int id;
  String? email;
  String? nickname;
  String? profileImageUrl;
  String? userCode;
  String? countryCode;
  bool? marketingChecked;
  bool? availableChangeNickname;
  bool? alarmEvent;
  bool? alarmTransaction;
  String? provider;

  MemberUserModel({
    required this.id,
    this.email,
    this.nickname,
    this.profileImageUrl,
    this.availableChangeNickname,
    this.userCode,
    this.countryCode,
    this.marketingChecked,
    this.alarmTransaction,
    this.alarmEvent,
    this.provider,
  });

  factory MemberUserModel.fromJson(Map<String, dynamic> json) => _$MemberUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberUserModelToJson(this);
}
