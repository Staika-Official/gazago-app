// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_challenge_available_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyChallengeAvailableModel _$CompanyChallengeAvailableModelFromJson(
        Map<String, dynamic> json) =>
    CompanyChallengeAvailableModel(
      id: (json['id'] as num).toInt(),
      alliancePromotionId: (json['alliancePromotionId'] as num).toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      employeeId: json['employeeId'] as String,
      name: json['name'] as String,
      departName: json['departName'] as String,
    );

Map<String, dynamic> _$CompanyChallengeAvailableModelToJson(
        CompanyChallengeAvailableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeId': instance.employeeId,
      'alliancePromotionId': instance.alliancePromotionId,
      'userId': instance.userId,
      'name': instance.name,
      'departName': instance.departName,
    };
