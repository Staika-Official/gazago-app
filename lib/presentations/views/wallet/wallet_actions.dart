import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/wallet_actions_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:get/get.dart';

class WalletActions extends StatelessWidget {
  const WalletActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletActionsController controller = Get.put(WalletActionsController());

    return Obx(() {
      return DefaultContainer(
        titleText: controller.pageHeader.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('From'),
                Row(
                  children: [
                    Expanded(child: TextField()),
                    Text('STIK'),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('보유: ${100.00.toString()}'),
                      TextButton(
                        onPressed: () => null,
                        child: Text('All'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.sp),
              child: Icon(
                Icons.keyboard_double_arrow_down,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('To'),
                Row(
                  children: [
                    Expanded(child: TextField()),
                    Text('TIK'),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('보유: ${100.00.toString()}'),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10.sp,
              ),
              child: Column(
                children: [
                  if (controller.actionType.value == WalletActionType.recharge)
                    Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('교환 비용'),
                          Text(
                            '1 STIK \u2248 100 TIK',
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('예상 수수료'),
                        Text(
                          '${0.005.toString()} STIK',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.sp),
              child: ElevatedButton(
                onPressed: () => null,
                child: Text(controller.actionType.value == WalletActionType.recharge ? '충전하기' : '보내기'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
