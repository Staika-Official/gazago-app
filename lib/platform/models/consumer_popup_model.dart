import 'package:json_annotation/json_annotation.dart';

part 'consumer_popup_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConsumerPopupModel {
  String type;
  double currentStat;
  int selectedStat;
  double resultStat;

  ConsumerPopupModel({
    required this.type,
    required this.currentStat,
    required this.selectedStat,
    required this.resultStat,
  });

  factory ConsumerPopupModel.fromJson(Map<String, dynamic> json) => _$ConsumerPopupModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsumerPopupModelToJson(this);
}
