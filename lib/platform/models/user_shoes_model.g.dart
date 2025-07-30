// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shoes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserShoesModelAdapter extends TypeAdapter<UserShoesModel> {
  @override
  final int typeId = 2;

  @override
  UserShoesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserShoesModel(
      id: fields[0] as int?,
      userId: fields[1] as int?,
      serialNumber: fields[2] as String?,
      itemName: fields[3] as String?,
      itemCategory: fields[4] as String?,
      durability: fields[5] as double?,
      abrasionRate: fields[6] as double?,
      rewardRate: fields[7] as double?,
      staminaReduceRate: fields[8] as double?,
      itemImageUrl: fields[9] as String?,
      description: fields[10] as String?,
      nftId: fields[11] as int?,
      itemId: fields[12] as int?,
      expiredDate: fields[13] as String?,
      itemStat: fields[14] as InventoryItemStatModel?,
    );
  }

  @override
  void write(BinaryWriter writer, UserShoesModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.serialNumber)
      ..writeByte(3)
      ..write(obj.itemName)
      ..writeByte(4)
      ..write(obj.itemCategory)
      ..writeByte(5)
      ..write(obj.durability)
      ..writeByte(6)
      ..write(obj.abrasionRate)
      ..writeByte(7)
      ..write(obj.rewardRate)
      ..writeByte(8)
      ..write(obj.staminaReduceRate)
      ..writeByte(9)
      ..write(obj.itemImageUrl)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.nftId)
      ..writeByte(12)
      ..write(obj.itemId)
      ..writeByte(13)
      ..write(obj.expiredDate)
      ..writeByte(14)
      ..write(obj.itemStat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserShoesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserShoesModel _$UserShoesModelFromJson(Map<String, dynamic> json) =>
    UserShoesModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      serialNumber: json['serialNumber'] as String?,
      itemName: json['itemName'] as String?,
      itemCategory: json['itemCategory'] as String?,
      durability: (json['durability'] as num?)?.toDouble(),
      abrasionRate: (json['abrasionRate'] as num?)?.toDouble(),
      rewardRate: (json['rewardRate'] as num?)?.toDouble(),
      staminaReduceRate: (json['staminaReduceRate'] as num?)?.toDouble(),
      itemImageUrl: json['itemImageUrl'] as String?,
      description: json['description'] as String?,
      nftId: (json['nftId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      expiredDate: json['expiredDate'] as String?,
      itemStat: json['itemStat'] == null
          ? null
          : InventoryItemStatModel.fromJson(
              json['itemStat'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserShoesModelToJson(UserShoesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'serialNumber': instance.serialNumber,
      'itemName': instance.itemName,
      'itemCategory': instance.itemCategory,
      'durability': instance.durability,
      'abrasionRate': instance.abrasionRate,
      'rewardRate': instance.rewardRate,
      'staminaReduceRate': instance.staminaReduceRate,
      'itemImageUrl': instance.itemImageUrl,
      'description': instance.description,
      'nftId': instance.nftId,
      'itemId': instance.itemId,
      'expiredDate': instance.expiredDate,
      'itemStat': instance.itemStat?.toJson(),
    };
