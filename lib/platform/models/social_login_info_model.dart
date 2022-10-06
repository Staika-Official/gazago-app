import 'package:json_annotation/json_annotation.dart';

part 'social_login_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SocialLoginInfoModel {
  String provider;
  String deviceId;
  String fcmToken;
  String token;
  String appVersion;
  String platform;
  String clientId;
  bool forceLogin;

  SocialLoginInfoModel({
    required this.provider,
    required this.deviceId,
    required this.fcmToken,
    required this.token,
    required this.appVersion,
    required this.platform,
    required this.clientId,
    required this.forceLogin,
  });

  factory SocialLoginInfoModel.fromJson(Map<String, dynamic> json) => _$SocialLoginInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginInfoModelToJson(this);
}
