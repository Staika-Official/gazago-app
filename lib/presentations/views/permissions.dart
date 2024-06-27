import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/permission_controller.dart';
import 'package:gaza_go/platform/models/permission_item_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class Permissions extends StatelessWidget {
  Permissions({Key? key}) : super(key: key);

  final List<PermissionItemModel> permissionsList = [
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_activity.svg', permissionName: '신체활동', isRequired: true, description: '걸음 수 확인 등'),
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_location.svg', permissionName: '위치', isRequired: true, description: '사용자 위치 파악, 운동 내역 계산 등'),
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_gallery.svg', permissionName: '사진', isRequired: false, description: '프로필 사진 등록 및 변경, 운동 기록 저장 등'),
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_camera.svg', permissionName: '카메라', isRequired: false, description: '프로필 사진 등록, 운동 코스 기록 등'),
  ];

  List<Widget> renderPermissionList() {
    return permissionsList
        .map((permission) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 0.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:2.0.sp),
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
                              style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                    color: AppColorData.regular().colorTextPrimary,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.sp),
                              child: Text(
                                permission.isRequired ? '(필수)' : '(선택)',
                                style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                                  color: AppColorData.regular().colorTextPrimary,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.sp),
                          child: Text(
                            permission.description,
                            style: AppTextStyleData.regular().koBodyMediumMd.copyWith(
                              color: AppColorData.regular().colorTextSecondary,
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
        padding: EdgeInsets.only(top: 20.sp, left: 16.sp, right: 16.sp, bottom: 30.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '접근 권한 안내',
                  style: AppTextStyleData.regular().koHeadingSemiboldMd.copyWith(
                    color: AppColorData.regular().colorTextPrimary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 9.sp, bottom: 10.sp),
                  child: Text(
                    '서비스 이용을 위해 아래 권한을 허용해 주시기 바랍니다.',
                    style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                      color: AppColorData.regular().colorTextSecondary,
                    ),

                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top:5.0.sp),
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
                "ㆍgazaGO는 운동 기록과 뱃지 획득 등의 기능 사용을 위해 앱이 닫혀 있을 때도 위치 데이터를 필요로 합니다. 원활한 서비스 이용을 위해 단말의 설정에서 위치 엑세스  권한을 ‘항상 허용'으로 설정해 주시길 바랍니다.",
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
                        '확인',
                            style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
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
