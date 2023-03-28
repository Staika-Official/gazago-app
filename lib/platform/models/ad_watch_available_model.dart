import 'package:json_annotation/json_annotation.dart';

part 'ad_watch_available_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AdWatchAvailableModel {
  bool? watchAvailable;
  String? latestWatchTime;

  AdWatchAvailableModel({
    this.watchAvailable,
    this.latestWatchTime,
  });

  factory AdWatchAvailableModel.fromJson(Map<String, dynamic> json) => _$AdWatchAvailableModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdWatchAvailableModelToJson(this);
}
