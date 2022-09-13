import 'package:json_annotation/json_annotation.dart';

part 'board_item_model.g.dart';

@JsonSerializable()
class BoardItemModel {
  int id;
  String boardType;
  String? status;
  String title;
  String? writerName;
  String? email;
  String content;
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
  String lastModifiedDate;

  BoardItemModel({
    required this.id,
    required this.boardType,
    this.status,
    required this.title,
    this.writerName,
    this.email,
    required this.content,
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
    required this.lastModifiedDate,
  });

  factory BoardItemModel.fromJson(Map<String, dynamic> json) =>
      _$BoardItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardItemModelToJson(this);
}
