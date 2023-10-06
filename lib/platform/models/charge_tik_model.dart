import 'package:json_annotation/json_annotation.dart';

part 'charge_tik_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChargeTikModel {
  int userId;
  String title;
  String fromTokenSymbol;
  double fromUiAmount;
  String toTokenSymbol;
  dynamic toUiAmount;
  double priceKRW;
  double priceUSD;
  double uiFeeString;

  ChargeTikModel({
    required this.userId,
    required this.title,
    required this.fromTokenSymbol,
    required this.fromUiAmount,
    required this.toTokenSymbol,
    required this.toUiAmount,
    required this.priceKRW,
    required this.priceUSD,
    required this.uiFeeString,
  });

  factory ChargeTikModel.fromJson(Map<String, dynamic> json) => _$ChargeTikModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeTikModelToJson(this);
}
