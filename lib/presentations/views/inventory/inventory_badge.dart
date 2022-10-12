import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryBadge extends StatelessWidget {
  const InventoryBadge({Key? key}) : super(key: key);

  List<Widget> renderUserBadgesList(InventoryController controller) {
    return controller.userBadgesList
        .map(
          (item) => InkWell(
            onTap: () => controller.toBadgeDetail(item.id),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1D1D26),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: item.state == 'EQUIPPED' ? 0.5 : 1,
                      child: CachedNetworkImage(
                        imageUrl: item.badge.imageUrl,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                      ),
                    ),
                    if (item.badge.name != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: StyledText(item.badge.name!),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: item.state == 'EQUIPPED'
                          ? InkWell(
                              onTap: () => null,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF363841),
                                  border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: const Color(0xFF8A8A8A),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StyledText(
                                    '장착 중',
                                    fontWeight: 500,
                                    fontSize: 14,
                                    color: Color(0xFF8A8A8A),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () => controller.fetchEquipBadge(item.badge.id),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF363841),
                                  border: Border.all(
                                    width: 1,
                                    style: BorderStyle.solid,
                                    color: const Color(0xFF54F5FF),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StyledText(
                                    '장착',
                                    fontWeight: 500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryController controller = Get.put(InventoryController());

    return Container(
      color: Color(0xFF363841),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Obx(() {
          return GridView.count(
            primary: false,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
            childAspectRatio: (1 / 1.4),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              ...renderUserBadgesList(controller),
            ],
          );
        }),
      ),
    );
  }
}
