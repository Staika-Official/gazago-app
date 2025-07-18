import 'package:json_annotation/json_annotation.dart';

part 'term_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TermItemModel {
  int? id;
  String? boardType;
  String? status;
  String? title;
  String? writerName;
  String? email;
  String? content;
  String? readAllow;
  String? meta;
  String? reserved;
  String? attach;
  int? readCount;
  int? commentCount;
  String? ip;
  String? showStartDate;
  String? showEndDate;
  int? createdId;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  bool isChecked;
  bool isRequired;

  TermItemModel({
    this.id,
    this.boardType,
    this.status,
    this.title,
    this.writerName,
    this.email,
    this.content,
    this.readAllow,
    this.meta,
    this.reserved,
    this.attach,
    this.readCount,
    this.commentCount,
    this.ip,
    this.showStartDate,
    this.showEndDate,
    this.createdId,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.isChecked = false,
    this.isRequired = false,
  });

  factory TermItemModel.fromJson(Map<String, dynamic> json) => _$TermItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermItemModelToJson(this);
}
