import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  List<Widget> renderLoginButtons(LoginController controller) {
    return LoginType.values.map((loginType) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 25.sp),
        width: double.infinity,
        child: SizedBox(
          height: 50.sp,
          child: InkWell(
            onTap: () {
              if(HiveStore.load(key: HiveKey.serviceStatus.name) == null ||HiveStore.load(key: HiveKey.serviceStatus.name) == 0){
                controller.login(loginType);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: getLoginButtonColor(loginType.name),
                borderRadius: BorderRadius.all(Radius.circular(10.sp)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  loginType.name != 'email' ? getLoginButtonIcon(loginType.name) : Container(),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0.sp),
                    child: StyledText(
                      '${getLoginButtonText(loginType.name)}로 로그인',
                      color: loginType.name == 'apple' ? Colors.white : Colors.black,
                      fontWeight: 500,
                      fontSize: 16,
                      lineHeight: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/common/bg_login.png'), alignment: Alignment(0, 0), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 38.0.sp),
                child: Center(
                  child: iconSplashLogo,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 48.0.sp),
              child: Column(
                children: [
                  ...renderLoginButtons(controller),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
