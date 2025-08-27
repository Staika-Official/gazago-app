import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/views/archive/components/archive_detail/detail_tab_content.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/constants/config.dart';
import 'package:gaza_go/platform/controllers/archive_controller.dart';
import 'package:gaza_go/platform/helpers/activity_helper.dart';
import 'package:gaza_go/platform/helpers/base_helper.dart';
import 'package:gaza_go/platform/helpers/map_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

import 'components/archive_detail/name_badge_section.dart';
import 'components/archive_detail/reward_tab_content.dart';

class ArchiveDetail extends StatelessWidget {
  const ArchiveDetail({super.key});

  @override
  Widget build(BuildContext context) {
    ArchiveController controller = Get.find()..fetchListReward();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: DefaultContainer(
        titleText: 'exercise_record_detail'.tr(),
        trailingChild: InkWell(
          child: IconButton(
            onPressed: () =>
                controller.showConfirmDelete(controller.selectedItem.value.id!),
            icon: iconWasteBasket,
            splashRadius: 32.sp,
            constraints: BoxConstraints(
              minWidth: 32.sp,
            ),
          ),
        ),
        backgroundColor: AppColorData.regular().colorBgPrimary,
        child: Column(
          children: [
            const NameBadgeSection(),
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: AppColorData.regular().colorBorderSecondary,
              indicatorColor: AppColorData.regular().colorBgBrand,
              labelStyle: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
              unselectedLabelStyle:
                  AppTextStyleData.regular().koBodyMediumLg.copyWith(
                        color: AppColorData.regular().colorTextTertiary,
                      ),
              tabs: [
                Tab(
                  text: 'exercise_details'.tr(),
                ),
                Tab(
                  text: 'rewards'.tr(),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  DetailTabContent(),
                  RewardTabContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
