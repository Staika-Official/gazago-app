import 'package:gaza_go/platform/models/new_challenge_badge_model.dart';
import 'package:gaza_go/platform/models/new_challenge_item_model.dart';
import 'package:gaza_go/platform/models/new_challenge_user_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_challenge_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NewChallengeDetailModel {
  int? id;
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
  String? linkUrl;
  bool? infinityDisplayed;
  bool? previewDisplayed;
  String? challengeRewardRuleType;
  int? rewardAmount;
  String? introduce;
  String? description;
  NewChallengeItemModel? item;
  NewChallengeUserItemModel? userItem;
  NewChallengeBadgeModel? badge;
  String? extBtnLabel;
  String? extTxt;
  String? extTxtDetail;

  NewChallengeDetailModel({
    this.id,
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
    this.linkUrl,
    this.infinityDisplayed,
    this.previewDisplayed,
    this.challengeRewardRuleType,
    this.rewardAmount,
    this.introduce,
    this.description,
    this.item,
    this.userItem,
    this.badge,
    this.extBtnLabel,
    this.extTxt,
    this.extTxtDetail,
  });

  factory NewChallengeDetailModel.fromJson(Map<String, dynamic> json) => _$NewChallengeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewChallengeDetailModelToJson(this);
}
