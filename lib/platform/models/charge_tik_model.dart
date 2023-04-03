import 'package:json_annotation/json_annotation.dart';

part 'charge_tik_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChargeTikModel {
  String title;
  String fromSymbol;
  double fromUiAmount;
  String toSymbol;
  int toUiAmount;
  double priceKRW;
  double priceUSD;

  ChargeTikModel({
    required this.title,
    required this.fromSymbol,
    required this.fromUiAmount,
    required this.toSymbol,
    required this.toUiAmount,
    required this.priceKRW,
    required this.priceUSD,
  });

  factory ChargeTikModel.fromJson(Map<String, dynamic> json) => _$ChargeTikModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeTikModelToJson(this);
}
