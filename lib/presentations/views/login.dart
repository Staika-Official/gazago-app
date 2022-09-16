import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/login_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  List<Widget> renderLoginButtons(LoginController controller) {
    return LoginType.values
        .map(
          (loginType) => Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.login(loginType),
              child: Text(loginType.name),
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
