import 'package:json_annotation/json_annotation.dart';

part 'notice_popup_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoticePopupModel {
  int? id;
  String? type;
  String? clientId;
  bool? displayed;
  bool? activated;
  int? listOrder;
  String? label;
  String? contentKo;
  String? contentEn;
  String? imageUrlKo;
  String? imageUrlEn;
  String? linkUrl;
  String? eventId;
  String? displayFromDate;
  String? displayToDate;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;

  NoticePopupModel({
    this.id,
    this.type,
    this.clientId,
    this.displayed,
    this.activated,
    this.listOrder,
    this.label,
    this.contentKo,
    this.contentEn,
    this.imageUrlKo,
    this.imageUrlEn,
    this.linkUrl,
    this.eventId,
    this.displayFromDate,
    this.displayToDate,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
  });

  factory NoticePopupModel.fromJson(Map<String, dynamic> json) => _$NoticePopupModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoticePopupModelToJson(this);
}
