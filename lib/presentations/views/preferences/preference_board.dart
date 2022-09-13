import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_go/platform/controllers/preference_board_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';

class PreferenceBoard extends StatelessWidget {
  const PreferenceBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenceBoardController controller = Get.put(PreferenceBoardController());

    return DefaultContainer(
      titleText: controller.boardName.value,
      child: Obx(() {
        return ListView.builder(
            itemCount: controller!.boardList.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
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
                  // initiallyExpanded: index == controller.selectedItem.value,
                  // onExpansionChanged: (newState) => controller.toggleItems(newState, index),
                  title: Text(
                    controller.boardList[index].title,
                    style: const TextStyle(
                      color: const Color(0xff292929),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('yyyy.MM.dd').format(DateTime.parse(
                        controller.boardList[index].lastModifiedDate)),
                    style: const TextStyle(
                      color: Color(0xffb7b7b7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 15,
                        right: 20,
                        bottom: 40,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xffcfcfcf),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Text(
                        controller.boardList[index].content,
                        style: const TextStyle(
                          color: Color(0xff292929),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
