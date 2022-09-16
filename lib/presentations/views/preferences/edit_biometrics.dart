import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gaza_go/platform/controllers/my_page_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';

class EditBiometrics extends StatelessWidget {
  const EditBiometrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyPageController controller = Get.find();
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('성별'),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.selectGender('MALE'),
                  child: Text('남자'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.selectGender('FEMALE'),
                  child: Text('여자'),
                ),
              ),
            ],
          ),
          Text('나이'),
          TextField(),
          Text('몸무게'),
          TextField(),
          Text('키'),
          TextField(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateBiometrics(),
                  child: Text('확인'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
