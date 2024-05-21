import 'package:gaza_go/platform/models/challenge_badge_model.dart';
import 'package:gaza_go/platform/models/challenge_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'challenge_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChallengeInfoModel {
  int? id;
  ChallengeItemModel? item;
  String? userItem;
  ChallengeBadgeModel? badge;
  List<ChallengeBadgeModel>? badges;
  int? itemTradeStoreId;
  String? challengeState;
  String? challengeUserState;
  String? challengeActivationType;
  List<String>? exerciseTypes;
  String? title;
  String? subTitle;
  int? minDistance;
  int? quantity;
  int? soldQuantity;
  String? publishedDate;
  String? reservedDate;
  String? fromDate;
  String? toDate;
  String? imageUrl;
  String? bannerImageUrl;
  String? thumbnailImageUrl;
  String? allianceType;
  String? linkUrl;
  String? extBtnLabel;
  String? extTxt;
  String? extTxtDetail;
  bool? previewDisplayed;
  String? challengeRewardRuleType;
  int? rewardAmount;
  int? rewardQuantity;
  String? introduce;
  String? description;

  ChallengeInfoModel({
    this.id,
    this.item,
    this.userItem,
    this.badge,
    this.badges,
    this.itemTradeStoreId,
    this.challengeState,
    this.challengeUserState,
    this.challengeActivationType,
    this.exerciseTypes,
    this.title,
    this.subTitle,
    this.minDistance,
    this.quantity,
    this.soldQuantity,
    this.publishedDate,
    this.reservedDate,
    this.fromDate,
    this.toDate,
    this.imageUrl,
    this.bannerImageUrl,
    this.thumbnailImageUrl,
    this.allianceType,
    this.linkUrl,
    this.extBtnLabel,
    this.extTxt,
    this.extTxtDetail,
    this.previewDisplayed,
    this.challengeRewardRuleType,
    this.rewardAmount,
    this.rewardQuantity,
    this.introduce,
    this.description,
  });

  factory ChallengeInfoModel.fromJson(Map<String, dynamic> json) => _$ChallengeInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeInfoModelToJson(this);
}
