// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardItemModel _$BoardItemModelFromJson(Map<String, dynamic> json) =>
    BoardItemModel(
      id: (json['id'] as num).toInt(),
      boardType: json['boardType'] as String,
      status: json['status'] as String?,
      title: json['title'] as String,
      writerName: json['writerName'] as String?,
      email: json['email'] as String?,
      content: json['content'] as String,
      readAllow: json['readAllow'] as String?,
      meta: json['meta'] as String?,
      reserved: json['reserved'] as String?,
      attach: json['attach'] as String?,
      readCount: (json['readCount'] as num?)?.toInt(),
      commentCount: (json['commentCount'] as num?)?.toInt(),
      ip: json['ip'] as String?,
      showStartDate: json['showStartDate'] as String?,
      showEndDate: json['showEndDate'] as String?,
      createdId: (json['createdId'] as num?)?.toInt(),
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
      lastModifiedDate: json['lastModifiedDate'] as String,
    );

Map<String, dynamic> _$BoardItemModelToJson(BoardItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boardType': instance.boardType,
      'status': instance.status,
      'title': instance.title,
      'writerName': instance.writerName,
      'email': instance.email,
      'content': instance.content,
      'readAllow': instance.readAllow,
      'meta': instance.meta,
      'reserved': instance.reserved,
      'attach': instance.attach,
      'readCount': instance.readCount,
      'commentCount': instance.commentCount,
      'ip': instance.ip,
      'showStartDate': instance.showStartDate,
      'showEndDate': instance.showEndDate,
      'createdId': instance.createdId,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate,
    };
