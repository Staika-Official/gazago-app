import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/models/repair_use_item_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';

class ItemCounter extends StatelessWidget {
  final RepairUseItemModel item;
  final Function callbackFnc;
  final int maxCount;

  const ItemCounter({Key? key, required this.item, required this.callbackFnc, required this.maxCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: popupBgColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (item.spendItemAmount! > 0) {
                      callbackFnc(item, item.spendItemAmount! - 1);
                    }
                  },
                  child: Container(
                    width: 26.sp,
                    height: 26.sp,
                    decoration: BoxDecoration(
                      color: item.spendItemAmount! > 0 ? skyBlueColor : lightGrayColor,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 3.sp),
                        )
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 13.sp,
                        height: 3.sp,
                        child: iconEaMinus,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                  child: Container(
                    width: 80.sp,
                    child: Center(
                      child: StyledText(
                        item.spendItemAmount.toString(),
                        fontSize: 20,
                        lineHeight: 26,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (maxCount > item.spendItemAmount!) {
                      callbackFnc(item, item.spendItemAmount! + 1);
                    }
                  },
                  child: Container(
                    width: 26.sp,
                    height: 26.sp,
                    decoration: BoxDecoration(
                      color: item.spendItemAmount! == maxCount ? lightGrayColor : skyBlueColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 3.sp),
                        )
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 13.sp,
                        height: 13.sp,
                        child: iconEaPlus,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
