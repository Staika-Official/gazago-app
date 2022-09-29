import 'package:json_annotation/json_annotation.dart';

part 'dummy_token_model.g.dart';

@JsonSerializable()
class DummyTokenModel {
  String name;
  double balance;
  String tokenImageUrl;

  DummyTokenModel({
    required this.name,
    required this.balance,
    required this.tokenImageUrl,
  });

  factory DummyTokenModel.fromJson(Map<String, dynamic> json) => _$DummyTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$DummyTokenModelToJson(this);
}
