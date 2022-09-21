import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  int id;
  String name;
  String serialNumber;
  String itemType;
  String itemCategory;
  String itemImageUrl;
  bool availableTrade;
  double abrasionRate;
  double rewardRate;
  double staminaReduceRate;
  double price;
  double recoveryRate;
  int listOrder;
  String description;
  String createdBy;
  String createdDate;
  String lastModifiedBy;
  String lastModifiedDate;
  bool isShoe;

  InventoryItemModel({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.itemType,
    required this.itemCategory,
    required this.availableTrade,
    required this.itemImageUrl,
    required this.abrasionRate,
    required this.rewardRate,
    required this.staminaReduceRate,
    required this.price,
    required this.recoveryRate,
    required this.listOrder,
    required this.description,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
    this.isShoe = false,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}
