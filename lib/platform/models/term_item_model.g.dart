// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermItemModel _$TermItemModelFromJson(Map<String, dynamic> json) =>
    TermItemModel(
      title: json['title'] as String,
      termType: json['termType'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      isRequired: json['isRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$TermItemModelToJson(TermItemModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'termType': instance.termType,
      'isChecked': instance.isChecked,
      'isRequired': instance.isRequired,
    };
