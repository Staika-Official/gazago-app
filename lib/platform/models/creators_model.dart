import 'package:json_annotation/json_annotation.dart';

part 'creators_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Creators {
  String? address;
  bool? verified;
  int? share;

  Creators({
    this.address,
    this.verified,
    this.share,
  });

  factory Creators.fromJson(Map<String, dynamic> json) => _$CreatorsFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorsToJson(this);
}
