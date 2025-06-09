import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:easy_localization/easy_localization.dart';

class FairPlayContent extends StatelessWidget {
  EdgeInsets padding = EdgeInsets.zero;
  FairPlayContent(
      {super.key,
      this.padding =
          const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 60)});

  Widget titleWidget(text, [textColor]) {
    return StyledText(
      text,
      fontSize: 16,
      fontWeight: 700,
      lineHeight: 24,
      color: textColor ?? Colors.white,
    );
  }

  Widget subtitleWidget(text) {
    return StyledText(
      text,
      fontSize: 14,
      fontWeight: 700,
      lineHeight: 22,
      color: skyBlueColor,
    );
  }

  Widget contentWidget(text, [subtext, textColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 7),
          child: StyledText(
            '\u22C5',
            fontSize: 14,
            lineHeight: 22,
            fontWeight: 500,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 22 / 14,
              ),
              children: [
                TextSpan(
                  text: '$text',
                ),
                if (subtext != null)
                  TextSpan(
                    text: '\n$subtext',
                    style: TextStyle(
                      color: lightGrayColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      height: 22 / 14,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            titleWidget('warning_and_ban_system_explanation'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('system_purpose'.tr()),
            ),
            contentWidget('card_issuance_process'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: titleWidget('warning_card_issuance_criteria'.tr()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget(
                  'warning_card_criteria_irregular_movement'.tr(),
                  'warning_card_criteria_example'.tr()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: titleWidget('ban_card_issuance_criteria'.tr()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('ban_card_criteria_multiple_logins'.tr()),
            ),
            contentWidget('ban_card_criteria_simultaneous_logins'.tr(),
                'ban_card_criteria_example'.tr()),
            contentWidget('ban_card_criteria_gps_manipulation'.tr()),
            contentWidget('ban_card_criteria_warning_accumulation'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('ban_card_criteria_other'.tr()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: contentWidget('ban_card_criteria_fairness_concerns'.tr()),
            ),
            contentWidget('ban_card_criteria_service_disruption'.tr(),
                'ban_card_criteria_service_disruption_example'.tr()),
            contentWidget('ban_card_criteria_service_error_abuse'.tr(),
                'ban_card_criteria_service_error_abuse_example'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: contentWidget(
                  'ban_card_criteria_fraudulent_transactions'.tr()),
            ),
            contentWidget('ban_card_criteria_personal_information_leak'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: titleWidget('card_penalties'.tr()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('warning_card_penalty'.tr()),
            ),
            contentWidget('warning_card_penalty_go_reset'.tr()),
            contentWidget('warning_card_penalty_service_restriction'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: subtitleWidget('ban_card_penalty'.tr()),
            ),
            contentWidget('ban_card_penalty_go_wallet_restriction'.tr()),
            contentWidget('ban_card_penalty_account_creation_restriction'.tr()),
            contentWidget('ban_card_penalty_permanent_restriction'.tr()),
            contentWidget('ban_card_penalty_reward_confiscation'.tr()),
            Padding(
              padding: const EdgeInsets.only(top: 32.0, bottom: 10),
              child: titleWidget(
                'notice_1'.tr(),
                lightGrayColor,
              ),
            ),
            contentWidget('terms_change_notice'.tr(), null, lightGrayColor),
            contentWidget(
                'cards_issued_to_all_accounts'.tr(), null, lightGrayColor),
            contentWidget('warning_ejection_records_permanent'.tr(), null,
                lightGrayColor),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: StyledText(
                'cooperation_for_fair_play'.tr(),
                fontWeight: 500,
                fontSize: 14,
                lineHeight: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
