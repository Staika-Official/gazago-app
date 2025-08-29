import 'package:flutter/widgets.dart';

extension ContextHelper on BuildContext {
  double get getBottomPadding => MediaQuery.paddingOf(this).bottom;
}