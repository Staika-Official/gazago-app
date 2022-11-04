import 'package:json_annotation/json_annotation.dart';

part 'member_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberUserModel {
  int id;
  String? email;
  String? nickname;
  String? profileImageUrl;
  String? userCode;
  bool? marketingChecked;
  bool? alarmEvent;
  bool? alarmTransaction;
  String? provider;

  MemberUserModel({
    required this.id,
    this.email,
    this.nickname,
    this.profileImageUrl,
    this.userCode,
    this.marketingChecked,
    this.alarmTransaction,
    this.alarmEvent,
    this.provider,
  });

  factory MemberUserModel.fromJson(Map<String, dynamic> json) => _$MemberUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberUserModelToJson(this);
}
