import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaza_go/platform/controllers/permission_controller.dart';
import 'package:gaza_go/platform/models/permission_item_model.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Permissions extends StatelessWidget {
  Permissions({Key? key}) : super(key: key);

  List<PermissionItemModel> permissionsList = [
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_activity.svg', permissionName: '신체활동', isRequired: true, description: '걸음 수 확인 등'),
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_location.svg', permissionName: '위치', isRequired: true, description: '사용자 위치 파악, 운동 내역 계산 등'),
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_gallery.svg', permissionName: '사진', isRequired: false, description: '프로필 사진 등록 및 변경, 운동 기록 저장 등'),
    PermissionItemModel(iconPath: 'assets/images/permissions/ico_camera.svg', permissionName: '카메라', isRequired: false, description: '프로필 사진 등록, 운동 코스 기록 등'),
  ];

  List<Widget> renderPermissionList() {
    return permissionsList
        .map((permission) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(permission.iconPath),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StyledText(
                              permission.permissionName,
                              fontSize: 18,
                              fontWeight: 500,
                              lineHeight: 18,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: StyledText(
                                permission.isRequired ? '(필수)' : '(선택)',
                                fontSize: 18,
                                fontWeight: 500,
                                lineHeight: 18,
                                color: const Color(0xff8a8a8a),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: StyledText(
                            permission.description,
                            fontSize: 14,
                            fontWeight: 500,
                            lineHeight: 14,
                            color: const Color(0xffbfbfbf),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: [
                const StyledText('접근 권한 안내', fontSize: 22, fontWeight: 500, lineHeight: 22),
                const Padding(
                  padding: EdgeInsets.only(top: 9, bottom: 10),
                  child: StyledText(
                    '원활한 서비스 이용을 위하여 아래 권한들을\n허용해 주시기 바랍니다.',
                    fontSize: 16,
                    fontWeight: 500,
                    lineHeight: 22,
                    color: Color(0xff8a8a8a),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 20,
              color: Color(0xff363841),
            ),
            ...renderPermissionList(),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 20,
              ),
              child: StyledText(
                "ㆍgazaGO는 운동 기록과 뱃지 획득 등의 기능 사용을 위해 앱이 닫혀 있을 때도 위치 데이터를 필요로 합니다. 원활한 서비스 이용을 위해 단말의 설정에서 위치 엑세스  권한을 ‘항상 허용'으로 설정해 주시길 바랍니다.",
                fontSize: 13,
                fontWeight: 500,
                lineHeight: 18,
                color: Color(0xff8a8a8a),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 55.sp,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EE6F3),
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () => controller.requestPermissions(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                          child: StyledText(
                        '확인',
                        fontSize: 18,
                        lineHeight: 18,
                        color: Colors.black,
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
