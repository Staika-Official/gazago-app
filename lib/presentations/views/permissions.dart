import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/permission_controller.dart';
import 'package:gaza_go/platform/models/permission_item_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class Permissions extends StatelessWidget {
  Permissions({super.key});

  List<Widget> renderPermissionList() {
    List<PermissionItemModel> permissionsList = [
      PermissionItemModel(
          iconPath: 'assets/images/permissions/ico_activity.svg',
          permissionName: 'physical_activity'.tr(),
          isRequired: true,
          description: 'step_count_etc'.tr()),
      PermissionItemModel(
          iconPath: 'assets/images/permissions/ico_location.svg',
          permissionName: 'location_access'.tr(),
          isRequired: true,
          description: 'location_tracking_etc'.tr()),
      PermissionItemModel(
          iconPath: 'assets/images/permissions/ico_gallery.svg',
          permissionName: 'photo'.tr(),
          isRequired: false,
          description: 'profile_photo_etc'.tr()),
      PermissionItemModel(
          iconPath: 'assets/images/permissions/ico_camera.svg',
          permissionName: 'camera'.tr(),
          isRequired: false,
          description: 'profile_photo_course_etc'.tr()),
    ];
    return permissionsList
        .map((permission) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 0.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.0.sp),
                    child: SvgPicture.asset(permission.iconPath),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              permission.permissionName,
                              style: AppTextStyleData.regular()
                                  .koBodyMediumXl
                                  .copyWith(
                                    color:
                                        AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.sp),
                              child: Text(
                                permission.isRequired
                                    ? 'required_access'.tr()
                                    : 'optional_access'.tr(),
                                style: AppTextStyleData.regular()
                                    .koBodyMediumXl
                                    .copyWith(
                                      color: AppColorData.regular()
                                          .colorTextPrimary,
                                    ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.sp),
                          child: Text(
                            permission.description,
                            style: AppTextStyleData.regular()
                                .koBodyMediumMd
                                .copyWith(
                                  color:
                                      AppColorData.regular().colorTextSecondary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    PermissionController controller = Get.put(PermissionController());

    return DefaultContainer(
      isLeadingShow: false,
      backgroundColor: subBg01Color,
      child: Padding(
        padding: EdgeInsets.only(
            top: 20.sp, left: 16.sp, right: 16.sp, bottom: 30.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'access_permission_guide'.tr(),
                  style:
                      AppTextStyleData.regular().koHeadingSemiboldMd.copyWith(
                            color: AppColorData.regular().colorTextPrimary,
                          ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 9.sp, bottom: 10.sp),
                  child: Text(
                    'access_permission_request'.tr(),
                    style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                          color: AppColorData.regular().colorTextSecondary,
                        ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0.sp),
              child: Divider(
                thickness: 1,
                height: 40.sp,
                color: popupBgColor,
              ),
            ),
            ...renderPermissionList(),
            Padding(
              padding: EdgeInsets.only(
                top: 20.sp,
              ),
              child: Text(
                'location_access_details'.tr(),
                style: AppTextStyleData.regular().koBodyMediumSm.copyWith(
                      color: AppColorData.regular().colorTextTertiary,
                    ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 55.sp,
                  decoration: BoxDecoration(
                    color: AppColorData.regular().colorBgInteractivePrimary,
                    border: Border.all(width: 2.sp, color: Colors.black),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: InkWell(
                    onTap: () => controller.requestPermissions(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                      child: Center(
                          child: Text(
                        'confirm'.tr(),
                        style:
                            AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                  color: AppColorData.regular().colorBaseBalck,
                                ),
                      )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
