import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/platform/models/referral_history_model.dart';
import 'package:gaza_go/presentations/components/base_card.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;

class ReferralHistoryList extends GetWidget<ReferralController> {
  const ReferralHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledText(
            'referral_history'.tr(),
            fontSize: 20,
            fontWeight: 700,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Flexible(
            child: Obx(
              () => controller.historyList.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        final item = controller.historyList[index];
                        return _HistoryItem(item);
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                      itemCount: controller.historyList.length,
                    )
                  : const _EmptyHistoryList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryList extends StatelessWidget {
  const _EmptyHistoryList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: BaseCard(
        borderRadius: 8.r,
        padding: EdgeInsets.all(20.r),
        child: StyledText(
          'no_referred_users'.tr(),
          fontSize: 20,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _HistoryItem extends GetWidget<ReferralController> {
  const _HistoryItem(this.item);

  final ReferralHistoryModel item;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      padding: EdgeInsets.all(20.r),
      borderRadius: 8.r,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  item.name,
                  fontSize: 20,
                  fontWeight: 700,
                ),
                SizedBox(height: 16.h),
                StyledText(
                  'rewards_x_go_points'.tr(args: ["${item.points}"]),
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
              ],
            ),
          ),

          // claim button
          if (!item.isClaimed)
            Material(
              color: buttonBgBlue,
              borderRadius: BorderRadius.circular(16.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: () {
                  controller.onClaimCodeReward(item.id);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 8.h,
                  ),
                  child: StyledText(
                    'claim'.tr(),
                    fontSize: 14,
                    fontWeight: 700,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            StyledText(
              'claimed'.tr(),
              fontSize: 14,
              fontWeight: 700,
              color:
                  item.isClaimed ? Colors.white.withOpacity(0.6) : Colors.white,
            )
        ],
      ),
    );
  }
}
