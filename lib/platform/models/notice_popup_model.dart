import 'package:json_annotation/json_annotation.dart';

part 'notice_popup_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoticePopupModel {
  int? id;
  String? type;
  String? clientId;
  bool? displayed;
  bool? activated;
  bool? mainDisplayed;
  int? listOrder;
  int? referenceId;
  int? challengeId;
  String? openType; //IN_APP, INTERNAL_WEB_VIEW, EXTERNAL_BROWSER
  String? label;
  String? contentKo;
  String? contentEn;
  String? imageUrlKo;
  String? imageUrlEn;
  String? subImageUrl;
  String? linkUrl;
  String? eventId;
  String? displayFromDate;
  String? displayToDate;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  bool? isAdsBanner;

  NoticePopupModel({
    this.id,
    this.type,
    this.clientId,
    this.displayed,
    this.activated,
    this.mainDisplayed,
    this.listOrder,
    this.referenceId,
    this.challengeId,
    this.openType,
    this.label,
    this.contentKo,
    this.contentEn,
    this.imageUrlKo,
    this.imageUrlEn,
    this.subImageUrl,
    this.linkUrl,
    this.eventId,
    this.displayFromDate,
    this.displayToDate,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.isAdsBanner,
  });

  factory NoticePopupModel.fromJson(Map<String, dynamic> json) => _$NoticePopupModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoticePopupModelToJson(this);
}
