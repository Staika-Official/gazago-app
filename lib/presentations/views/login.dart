import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/platform/helpers/login_helper.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  List<Widget> renderLoginButtons(LoginController controller) {
    return LoginType.values
        .map(
          (loginType) => Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            width: double.infinity,
            child: SizedBox(
              height: 50,
              child: InkWell(
                onTap: () => controller.login(loginType),
                child: Container(
                  decoration: BoxDecoration(
                    color: getLoginButtonColor(loginType.name),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      loginType.name != 'email' ? getLoginButtonIcon(loginType.name) : Container(),
                      StyledText(
                        '${getLoginButtonText(loginType.name)}로 로그인',
                        color: loginType.name == 'apple' ? Colors.white : Colors.black,
                        fontWeight: 500,
                        fontSize: 16,
                        lineHeight: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController();

    return DefaultContainer(
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text('gazaGo'),
            ),
          ),
          ...renderLoginButtons(controller),
        ],
      ),
    );
  }
}
