// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_popup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticePopupModel _$NoticePopupModelFromJson(Map<String, dynamic> json) =>
    NoticePopupModel(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      clientId: json['clientId'] as String?,
      displayed: json['displayed'] as bool?,
      activated: json['activated'] as bool?,
      mainDisplayed: json['mainDisplayed'] as bool?,
      listOrder: (json['listOrder'] as num?)?.toInt(),
      referenceId: (json['referenceId'] as num?)?.toInt(),
      challengeId: (json['challengeId'] as num?)?.toInt(),
      openType: json['openType'] as String?,
      label: json['label'] as String?,
      contentKo: json['contentKo'] as String?,
      contentEn: json['contentEn'] as String?,
      imageUrlKo: json['imageUrlKo'] as String?,
      imageUrlEn: json['imageUrlEn'] as String?,
      subImageUrl: json['subImageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      eventId: json['eventId'] as String?,
      displayFromDate: json['displayFromDate'] as String?,
      displayToDate: json['displayToDate'] as String?,
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String?,
      isAdsBanner: json['isAdsBanner'] as bool?,
    );

Map<String, dynamic> _$NoticePopupModelToJson(NoticePopupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'clientId': instance.clientId,
      'displayed': instance.displayed,
      'activated': instance.activated,
      'mainDisplayed': instance.mainDisplayed,
      'listOrder': instance.listOrder,
      'referenceId': instance.referenceId,
      'challengeId': instance.challengeId,
      'openType': instance.openType,
      'label': instance.label,
      'contentKo': instance.contentKo,
      'contentEn': instance.contentEn,
      'imageUrlKo': instance.imageUrlKo,
      'imageUrlEn': instance.imageUrlEn,
      'subImageUrl': instance.subImageUrl,
      'linkUrl': instance.linkUrl,
      'eventId': instance.eventId,
      'displayFromDate': instance.displayFromDate,
      'displayToDate': instance.displayToDate,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
      'isAdsBanner': instance.isAdsBanner,
    };
