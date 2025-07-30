// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefit_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BenefitItemModel _$BenefitItemModelFromJson(Map<String, dynamic> json) =>
    BenefitItemModel(
      id: (json['id'] as num).toInt(),
      benefitType: json['benefitType'] as String,
      distance: (json['distance'] as num).toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      adDisplayed: json['adDisplayed'] as bool,
      label: json['label'] as String,
      labelReceived: json['labelReceived'] as String,
      received: json['received'] as bool,
      benefitDate: json['benefitDate'] as String?,
      trackingId: json['trackingId'] as String?,
    );

Map<String, dynamic> _$BenefitItemModelToJson(BenefitItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'benefitType': instance.benefitType,
      'distance': instance.distance,
      'amount': instance.amount,
      'imageUrl': instance.imageUrl,
      'adDisplayed': instance.adDisplayed,
      'label': instance.label,
      'labelReceived': instance.labelReceived,
      'received': instance.received,
      'benefitDate': instance.benefitDate,
      'trackingId': instance.trackingId,
    };
