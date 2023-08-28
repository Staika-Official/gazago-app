import 'package:gaza_go/platform/models/repair_use_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_stamina_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RecoveryStaminaModel {
  String recoveryUuid;
  List<RepairUseItemModel> recoveryItems;

  RecoveryStaminaModel({
    required this.recoveryUuid,
    required this.recoveryItems,
  });

  factory RecoveryStaminaModel.fromJson(Map<String, dynamic> json) => _$RecoveryStaminaModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecoveryStaminaModelToJson(this);
}
