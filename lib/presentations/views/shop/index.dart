import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/shop_controller.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/presentations/views/shop/shop_items.dart';
import 'package:get/get.dart';

class ShopHome extends StatelessWidget {
  const ShopHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopController shopController = Get.put(ShopController());
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: shopController.singleChildScrollController,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 80.sp,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 18.0.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0.sp, right: 25.0.sp, bottom: 10.sp),
                child: StyledText(
                  '상점',
                  fontSize: 18.sp,
                  fontWeight: 500,
                ),
              ),
              const Expanded(child: ShopItems()),
            ],
          ),
        ),
      ),
    );
  }
}
