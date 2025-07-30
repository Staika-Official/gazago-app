// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_stat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryItemStatModelAdapter
    extends TypeAdapter<InventoryItemStatModel> {
  @override
  final int typeId = 4;

  @override
  InventoryItemStatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryItemStatModel(
      goProfit: fields[0] as double?,
      durability: fields[1] as double?,
      stamina: fields[2] as double?,
      luck: fields[3] as double?,
      recoveryStamina: fields[4] as double?,
      repairDurability: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryItemStatModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.goProfit)
      ..writeByte(1)
      ..write(obj.durability)
      ..writeByte(2)
      ..write(obj.stamina)
      ..writeByte(3)
      ..write(obj.luck)
      ..writeByte(4)
      ..write(obj.recoveryStamina)
      ..writeByte(5)
      ..write(obj.repairDurability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItemStatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItemStatModel _$InventoryItemStatModelFromJson(
        Map<String, dynamic> json) =>
    InventoryItemStatModel(
      goProfit: (json['goProfit'] as num?)?.toDouble(),
      durability: (json['durability'] as num?)?.toDouble(),
      stamina: (json['stamina'] as num?)?.toDouble(),
      luck: (json['luck'] as num?)?.toDouble(),
      recoveryStamina: (json['recoveryStamina'] as num?)?.toDouble(),
      repairDurability: (json['repairDurability'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InventoryItemStatModelToJson(
        InventoryItemStatModel instance) =>
    <String, dynamic>{
      'goProfit': instance.goProfit,
      'durability': instance.durability,
      'stamina': instance.stamina,
      'luck': instance.luck,
      'recoveryStamina': instance.recoveryStamina,
      'repairDurability': instance.repairDurability,
    };
