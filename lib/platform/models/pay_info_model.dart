import 'package:gaza_go/platform/models/asset_short_amount_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pay_info_model.g.dart';

@JsonSerializable()
class PayInfoModel {
  int? recipient; //결제 대금을 받을 사용자의 user id (회사가 받는다면, null)
  AssetShortAmountModel amount;
  AssetShortAmountModel fee;
  String label; //enum [ 체력충전, 내구도충전, 아이템수리, 아이템구매, 배지합성, 배지구매, TIK충전 ]
  String? memo;

  PayInfoModel({
    this.recipient,
    required this.amount,
    required this.fee,
    required this.label,
    this.memo,
  });

  factory PayInfoModel.fromJson(Map<String, dynamic> json) => _$PayInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayInfoModelToJson(this);
}
