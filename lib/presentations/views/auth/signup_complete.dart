import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class SignupComplete extends StatelessWidget {
  const SignupComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
    return DefaultContainer(
      isLeadingShow: false,
      backgroundColor: AppColorData.regular().colorBgPrimary,
      child: Padding(
        padding: EdgeInsets.only(left:16.sp, right: 16.sp, top: 16.sp, bottom: 30.sp),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 70.0.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0.sp),
                              child:iconSkyBlueCheck,
                            ),
                            Text(
                              '회원가입이 완료되었습니다.',
                              style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 12.0.sp),
                              child: Text(
                                '이제 gazaGO와 함께\n즐겁게 운동해 보세요.',
                                style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                  color: AppColorData.regular().colorTextSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                if(loginController.isAlreadySigninUser.value)
                  Padding(
                    padding: EdgeInsets.only(left: 12.sp, right: 12.sp, bottom: 62.0.sp),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorData.regular().colorBgTransparcy80,
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0.sp, horizontal: 20.0.sp),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              '기존에 가입된 회원정보가 있어\n계정 연동을 완료했습니다. 연결된 계정은\n‘설정 > 계정정보 > SNS로그인’에서\n확인할 수 있어요.',
                              style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                                color: AppColorData.regular().colorTextPrimary,
                              ),
                              softWrap: true  ,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                height: 55.sp,
                decoration: BoxDecoration(
                  color: AppColorData.regular().colorBgInteractivePrimary,
                  border: Border.all(width: 2.sp, color: Colors.black),
                  borderRadius: BorderRadius.circular(8.sp),

                ),
                child: InkWell(
                  onTap: () => Get.offAllNamed(Routes.loading),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.sp),
                    child:  Center(
                        child: Text(
                      '시작하기',
                          style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                            color: AppColorData.regular().colorBaseBalck,
                          ),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
