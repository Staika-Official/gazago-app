import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/my_page_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;

class EditBiometrics extends StatelessWidget {
  const EditBiometrics({super.key});

  @override
  Widget build(BuildContext context) {
    MyPageController controller = Get.find();
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('gender'.tr()),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => null,
                  child: Text('male'.tr()),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => null,
                  child: Text('female'.tr()),
                ),
              ),
            ],
          ),
          Text('age'.tr()),
          const TextField(),
          Text('weight'.tr()),
          const TextField(),
          Text('height'.tr()),
          const TextField(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateBiometrics(),
                  child: Text('confirm'.tr()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
