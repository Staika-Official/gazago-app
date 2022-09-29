import 'package:json_annotation/json_annotation.dart';

part 'access_token_model.g.dart';

@JsonSerializable()
class AccessTokenModel {
  String accessToken;
  String refreshToken;
  String? accountStatus;

  AccessTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accountStatus,
  });

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) => _$AccessTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenModelToJson(this);
}
