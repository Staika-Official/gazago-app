import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/preference_board_controller.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PreferenceBoard extends StatelessWidget {
  const PreferenceBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceBoardController controller = Get.put(PreferenceBoardController());

    return DefaultContainer(
      titleText: controller.boardName.value,
      child: Obx(() {
        return ListView.builder(
            itemCount: controller.boardList.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.only(
                      left: 20,
                      // top: 14,
                      right: 15,
                      // bottom: 14,
                    ),
                    iconColor: const Color(0xff292929),
                    collapsedIconColor: const Color(0xff292929),
                    textColor: const Color(0xff292929),
                    collapsedTextColor: const Color(0xff292929),
                    title: StyledText(
                      controller.boardList[index].title!,
                      color: Colors.white,
                      fontSize: 18,
                      lineHeight: 22,
                      fontWeight: 500,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: StyledText(
                        DateFormat('yyyy.MM.dd').format(DateTime.parse(controller.boardList[index].lastModifiedDate!)),
                        color: Colors.white,
                        fontSize: 12,
                        lineHeight: 14,
                        fontWeight: 600,
                        fontFamily: 'Monserrat',
                      ),
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          left: 20,
                          top: 10,
                          right: 20,
                          bottom: 40,
                        ),
                        padding: EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xff363841),
                              width: 2,
                            ),
                          ),
                        ),
                        child: StyledText(
                          controller.boardList[index].content!,
                          color: Color(0xffbfbfbf),
                          fontSize: 16,
                          lineHeight: 22,
                          fontWeight: 500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
