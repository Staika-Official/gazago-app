import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admob_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable(explicitToJson: true)
class AdmobModel {
  @HiveField(0)
  String? startFamousAd;
  @HiveField(1)
  String? startHikingAd;
  @HiveField(2)
  String? startWalkingAd;
  @HiveField(3)
  String? endFamousAd;
  @HiveField(4)
  String? endHikingAd;
  @HiveField(5)
  String? endWalkingAd;

  AdmobModel({
    this.startFamousAd,
    this.startHikingAd,
    this.startWalkingAd,
    this.endFamousAd,
    this.endHikingAd,
    this.endWalkingAd,
  });

  factory AdmobModel.fromJson(Map<String, dynamic> json) =>
      _$AdmobModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdmobModelToJson(this);
}
