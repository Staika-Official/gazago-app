import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileModel {
  int id;
  String nickname;
  String profileImageUrl;
  String walletAddress;
  String socialAccounts;
  String email;
  String gender;
  int age;
  double weight;
  double height;

  ProfileModel({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    required this.walletAddress,
    required this.socialAccounts,
    required this.email,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
