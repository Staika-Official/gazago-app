import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/models/repair_use_item_model.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:gaza_go/theme/theme.g.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (item.spendItemAmount! > 0) {
                      callbackFnc(item, item.spendItemAmount! - 1);
                    }
                  },
                  child: Container(
                    width: 20.sp,
                    height: 20.sp,
                    decoration: BoxDecoration(
                      color: item.spendItemAmount! > 0 ? AppColorData.regular().colorBgInteractivePrimary : AppColorData.regular().colorBgInteractivePrimaryDisabled,
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
                    width: 40.sp,
                    child: Center(
                      child: Text(
                        item.spendItemAmount.toString(),
                        style: AppTextStyleData.regular().koBodyMediumXl.copyWith(
                              color: AppColorData.regular().colorTextPrimary,
                            ),
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
                    width: 20.sp,
                    height: 20.sp,
                    decoration: BoxDecoration(
                      color: item.spendItemAmount! == maxCount ? AppColorData.regular().colorBgInteractivePrimaryDisabled : AppColorData.regular().colorBgInteractivePrimary,
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
