import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/platform/models/referral_history_model.dart';
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
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20.h),
          Flexible(
            child: Obx(
              () => controller.historyList.isNotEmpty
                  ? ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final item = controller.historyList[index];
                        return _HistoryItem(item);
                      },
                      separatorBuilder: (_, __) => Container(
                        height: 1,
                        color: const Color(0xFF2A2B33),
                      ),
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
    return Column(
      children: [
        SizedBox(height: 24.h),
        Image.asset(
          'assets/images/referral/ico_empty_referral.png',
          width: 100,
          height: 100,
        ),
        SizedBox(height: 20.h),
        StyledText(
          'no_referred_users'.tr(),
          fontSize: 16,
          fontWeight: 500,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HistoryItem extends GetWidget<ReferralController> {
  const _HistoryItem(this.item);

  final ReferralHistoryModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          // Circular avatar with white border
          Container(
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: CustomPaint(
                  painter: CheckerboardPainter(),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  item.name,
                  fontSize: 16,
                  fontWeight: 500,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    StyledText(
                      'rewards_colon'.tr(),
                      fontSize: 10,
                      fontWeight: 500,
                      color: Color(0xFFC9C5C6),
                    ),
                    StyledText(
                      '${item.points} ${'gem_unit'.tr()}',
                      fontSize: 10,
                      fontWeight: 500,
                      color: const Color(0xFF0EE6F3),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Cyan checkmark icon
          const Icon(
            Icons.check,
            color: Color(0xFF0EE6F3),
            size: 20,
          ),
        ],
      ),
    );
  }
}

// Custom painter for checkered pattern
class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final squareSize = size.width / 4;

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if ((i + j) % 2 == 0) {
          paint.color = Colors.white;
        } else {
          paint.color = Colors.black;
        }
        canvas.drawRect(
          Rect.fromLTWH(i * squareSize, j * squareSize, squareSize, squareSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
