import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  String accessToken;
  String refreshToken;
  String? accountStatus;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accountStatus,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
