import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/controllers/term_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class Term extends StatelessWidget {
  const Term({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TermController _controller = Get.put(TermController());

    return DefaultContainer(
      titleText: _controller.termType.value,
      child: Center(
        child: Text(_controller.termType.value),
      ),
    );
  }
}
