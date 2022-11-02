import 'package:flutter/material.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/preference_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class TermsList extends StatelessWidget {
  const TermsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceController controller = Get.put(PreferenceController());

    return DefaultContainer(
      titleText: '약관',
      backgroundColor: const Color(0xFF1D1D26),
      headerBackgroundColor: Color(0xFF1D1D26),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            TermsListItem(
              title: '이용약관',
              onTap: () => Get.toNamed(Routes.term, arguments: {'termType': 'T2E_TERMS'}),
            ),
            TermsListItem(
              title: '위치정보 이용 동의',
              onTap: () => Get.toNamed(Routes.term, arguments: {'termType': 'T2E_LOCATION'}),
            ),
          ],
        ),
      ),
    );
  }
}

enum ItemType { functional, descriptive }

class TermsListItem extends StatelessWidget {
  final String title;
  final ItemType type;
  final VoidCallback? onTap;
  final String? description;

  const TermsListItem({Key? key, required this.title, this.type = ItemType.functional, this.onTap, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: type == ItemType.functional ? onTap : null,
        child: Container(
          height: 55,
          color: Color(0xFF1D1D26),
          padding: const EdgeInsets.only(left: 25, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(
                title,
                fontSize: 18,
              ),
              type == ItemType.functional
                  ? const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFBDC0C7),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: StyledText(
                        'v${description!}',
                        fontSize: 16,
                        fontWeight: 500,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
