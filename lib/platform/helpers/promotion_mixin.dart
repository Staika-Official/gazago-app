import 'package:gaza_go/platform/models/promotion_ad_model.dart';
import 'package:gaza_go/platform/services/activity_service.dart';

class PromotionMixin {
  List<PromotionAdModel> promotionAdsList = List.empty(growable: true);

  Future<void> getPromotionAdsList() async {
    await ActivityService.getPromotionAdsList(
        successCallback: (data) {
          promotionAdsList.addAll(data);
        },
        errorCallback: () {});
  }
}
