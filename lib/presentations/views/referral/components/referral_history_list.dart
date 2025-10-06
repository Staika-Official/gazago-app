import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/referral_controller.dart';
import 'package:gaza_go/platform/models/referee_model.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart' hide Trans;

class ReferralHistoryList extends GetWidget<ReferralController> {
  const ReferralHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    // Listen to scroll events
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.8) {
        controller.loadMoreReferees();
      }
    });
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
              () {
                if (controller.refereesLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.refereesList.isNotEmpty) {
                  return Obx(() {
                    final itemCount = controller.refereesList.length +
                        (controller.hasMoreData.value ? 1 : 0);

                    return ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        if (index < controller.refereesList.length) {
                          final referee = controller.refereesList[index];
                          return _RefereeItem(referee);
                        }

                        return const _LoadMoreIndicator();
                      },
                      separatorBuilder: (_, index) {
                        if (index >= controller.refereesList.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          height: 1,
                          color: const Color(0xFF2A2B33),
                        );
                      },
                      itemCount: itemCount,
                    );
                  });
                } else {
                  return const _EmptyHistoryList();
                }
              },
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

// Custom painter for checkered pattern
class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Use the smaller dimension to ensure squares fit properly in circular bounds
    final dimension = size.width < size.height ? size.width : size.height;
    final squareSize = dimension / 4;

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

class _LoadMoreIndicator extends GetWidget<ReferralController> {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Container(
          padding: EdgeInsets.all(20.h),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EE6F3)),
            ),
          ),
        );
      }

      if (controller.hasMoreData.value) {
        return Container(
          padding: EdgeInsets.all(20.h),
          child: Center(
            child: TextButton(
              onPressed: () => controller.loadMoreReferees(),
              child: const StyledText(
                'Load',
                fontSize: 14,
                fontWeight: 500,
                color: Color(0xFF0EE6F3),
              ),
            ),
          ),
        );
      }

      return Container(
        padding: EdgeInsets.all(20.h),
        child: Center(
          child: StyledText(
            'No more data',
            fontSize: 12,
            fontWeight: 400,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      );
    });
  }
}

class _RefereeItem extends GetWidget<ReferralController> {
  const _RefereeItem(this.referee);

  final RefereeModel referee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40
                .w, // Use .w for both dimensions to maintain square aspect ratio
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
                child: AspectRatio(
                  aspectRatio: 1.0, // Ensure 1:1 aspect ratio
                  child: CustomPaint(
                    painter: CheckerboardPainter(),
                  ),
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
                  referee.username,
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
                      color: const Color(0xFFC9C5C6),
                    ),
                    StyledText(
                      '${referee.amount} ${'gem_unit'.tr()}',
                      fontSize: 10,
                      fontWeight: 500,
                      color: const Color(0xFF0EE6F3),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
