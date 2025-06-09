import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/styles/icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gaza_go/theme/theme.g.dart';

class ViewSolscanButton extends StatelessWidget {
  const ViewSolscanButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'view_solscan'.tr(),
            style: AppTextStyleData.regular().koBodySemiboldMd.copyWith(
                  color: AppColorData.regular().colorTextTertiary,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 1.0, top: 3),
            child: iconWebview,
          ),
        ],
      ),
    );
  }
}
