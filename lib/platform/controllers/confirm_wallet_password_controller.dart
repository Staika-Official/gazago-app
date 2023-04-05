import 'package:gaza_go/constants/routes.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as RX;

enum FormStatus { empty, insufficient, sufficient }

enum ErrorStatus { basic, insufficient, notSame, sufficient }

extension ErrorStatusExtension on ErrorStatus {
  String get toStr {
// tododo
    switch (this) {
      case ErrorStatus.basic:
        return '8~16자로 영문, 숫자, 특수문자를 조합해주세요.';
      case ErrorStatus.insufficient:
        return '8~16자로 영문, 숫자, 특수문자를 조합해주세요.';
      case ErrorStatus.notSame:
        return '8~16자로 영문, 숫자, 특수문자를 조합해주세요.';
      case ErrorStatus.sufficient:
        return '8~16자로 영문, 숫자, 특수문자를 조합해주세요.';
    }
  }

  String get toAsset {
// tododo
    switch (this) {
      case ErrorStatus.basic:
        return 'assets/images/icons/icon_password_default.svg';
      case ErrorStatus.insufficient:
        return 'assets/images/icons/icon_password_invalid.svg';
      case ErrorStatus.notSame:
        return 'assets/images/icons/icon_password_invalid.svg';
      case ErrorStatus.sufficient:
        return 'assets/images/icons/icon_password_valid.svg';
    }
  }
}

//TODO 전체적인 로직 수정 필요

class ConfirmWalletPasswordController extends GetxController {
  final RegExp _regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$');
  final RxString _password = ''.obs;
  final RxString _confirmPassword = ''.obs;
  final Rx<FormStatus> _passwordFormStatus = Rx(FormStatus.empty);
  final Rx<ErrorStatus> _errorStatus = Rx(ErrorStatus.basic);

  late Stream<bool> _isSamePassword;

  initSamePasswordStream() {
    _isSamePassword = RX.CombineLatestStream.combine2<String, String, bool>(_password.stream, _confirmPassword.stream, (a, b) => a == b);
  }

  Stream<bool> isEnableNextStep() {
    return RX.CombineLatestStream.combine2<FormStatus, bool, bool>(_passwordFormStatus.stream, _isSamePassword, (status, isSame) {
      _setErrorState(isSame, status);
      return status == FormStatus.sufficient && isSame;
    });
  }

  Stream<ErrorStatus> getErrorStatusStream() {
    return _errorStatus.stream;
  }

  String getPassword() {
    return _password.value;
  }

  _setErrorState(bool isSame, FormStatus status) {
    if (isSame) {
      switch (status) {
        case FormStatus.empty:
          _errorStatus.value = ErrorStatus.basic;
          break;
        case FormStatus.insufficient:
          _errorStatus.value = ErrorStatus.insufficient;
          break;
        case FormStatus.sufficient:
          _errorStatus.value = ErrorStatus.sufficient;
          break;
      }
    } else {
      _errorStatus.value = ErrorStatus.notSame;
    }
  }

  FormStatus _verifyPassword(String password) {
    if (password.isEmpty) {
      return FormStatus.empty;
    }
    if (!_regExp.hasMatch(password)) {
      return FormStatus.insufficient;
    }
    return FormStatus.sufficient;
  }

  final Rx<FormStatus> passwordFormStatus = Rx(FormStatus.empty);
  final Rx<FormStatus> confirmPasswordFormStatus = Rx(FormStatus.empty);
  final RxBool isEnableNext = false.obs;
  final Rx<ErrorStatus> errorMsg = Rx(ErrorStatus.basic);
  final RxBool isOneTime = false.obs;

  @override
  void onInit() {
    super.onInit();
    initSamePasswordStream();
    isEnableNextStep().listen((isEnableNext) {
      this.isEnableNext.value = isEnableNext;
    });
    getErrorStatusStream().listen((event) {
      errorMsg.value = event;
    });
  }

  @override
  void onReady() {
    isOneTime.value = true;
  }

  @override
  void onClose() {
    isOneTime.value = false;
  }

  void updatePassword(String password) {
    _password.value = password;
    _passwordFormStatus.value = _verifyPassword(password);
    passwordFormStatus.value = _passwordFormStatus.value;
  }

  void updateConfirmPassword(String password) {
    _confirmPassword.value = password;
    confirmPasswordFormStatus.value = _verifyPassword(password);
  }

  void nextStep() {
    print('create wallet view');
    Get.offNamed(Routes.createWallet);
  }
}
