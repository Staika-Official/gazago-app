import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:gaza_go/theme/theme.g.dart';
import 'package:get/get.dart';

class BottomSheetAlert extends StatelessWidget {
  final String? title;
  final String? contentText;
  final Widget? contentWidget;
  final List<Widget> actions;
  final bool? isDangerTitle;
  final bool? isNonePaddingOuter;
  final bool? isFullHeight;

  const BottomSheetAlert({super.key, this.title, this.contentText, this.contentWidget, this.isDangerTitle, this.isNonePaddingOuter, this.isFullHeight, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: popupBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.sp),
          topRight: Radius.circular(12.sp),
        ),
      ),
      child: SizedBox(
        height: isFullHeight! ? MediaQuery.of(context).size.height - 80 : null,
        child: Padding(
          padding: isNonePaddingOuter! ? const EdgeInsets.all(0) : EdgeInsets.only(top: 32.0.sp, left: 16.sp, right: 16.sp, bottom: 36.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: EdgeInsets.only(top: 0.sp),
                  child: Text(
                    title!,
                    style: AppTextStyleData.regular().koHeadingMediumSm.copyWith(
                      height: 1,
                      color: isDangerTitle! ? AppColorData.regular().colorTextWarning : AppColorData.regular().colorTextPrimary,
                    ),

                  ),
                ),
              contentWidget ??
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.sp, bottom: 32.sp),
                    child: Text(
                      contentText!,
                      style: AppTextStyleData.regular().koBodyMediumLg.copyWith(
                        color: AppColorData.regular().colorTextPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: actions.isNotEmpty
                    ? actions
                    : [
                        Expanded(
                          child: GazagoButton(
                            onTap: () => Get.until((route) => Get.isBottomSheetOpen == false && Get.isDialogOpen == false),
                            buttonText: '확인',
                            buttonColor: skyBlueColor,
                          ),
                        ),
                      ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
