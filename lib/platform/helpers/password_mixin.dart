import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/security_helper.dart';
import 'package:easy_localization/easy_localization.dart';

mixin PasswordMixin {
  setErrorState(
    FormStatus status,
    ErrorStatus errorStatus, {
    bool? isSame,
  }) {
    switch (status) {
      case FormStatus.empty:
        errorStatus = ErrorStatus.basic;
        break;
      case FormStatus.insufficient:
        errorStatus = ErrorStatus.insufficient;
        break;
      case FormStatus.sufficient:
        errorStatus = ErrorStatus.sufficient;
        break;
    }

    if (isSame != null && !isSame) {
      errorStatus = ErrorStatus.notSame;
    }
  }

  FormStatus verifyPassword(String password) {
    if (password.isEmpty) {
      return FormStatus.empty;
    }
    if (!passwordRegExp.hasMatch(password)) {
      return FormStatus.insufficient;
    }
    return FormStatus.sufficient;
  }

  FormStatus verifyConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) {
      return FormStatus.empty;
    }
    if (!passwordRegExp.hasMatch(password) || confirmPassword != password) {
      return FormStatus.insufficient;
    }
    return FormStatus.sufficient;
  }

  FormStatus verifyConfirmText(String confirmText) {
    if (confirmText.isEmpty) {
      return FormStatus.empty;
    }
    if (confirmText != 'confirmed'.tr()) {
      return FormStatus.insufficient;
    }
    return FormStatus.sufficient;
  }
}
