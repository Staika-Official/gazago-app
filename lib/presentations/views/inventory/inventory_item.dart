import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({Key? key}) : super(key: key);

  List<Widget> renderItemSubTabList(InventoryHomeController controller) {
    return controller.itemSubTabList
        .map(
          (item) => Text(item['title']),
        )
        .toList();
  }

  List<Widget> renderItemList(InventoryHomeController homeController, InventoryController controller, double width, double height) {
    return homeController.itemSubTabList
        .map(
          (tab) => GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            controller: new ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.only(left: 20, right: 20),
            childAspectRatio: (1 / 1.4),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: (width < 350) ? 2 : 3,
            children: [
              ...controller.allItems[tab['itemType']]!.map(
                (item) => InkWell(
                  onTap: () => controller.toItemDetail(item.id),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1D1D26),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: item.equipped == true ? 0.5 : 1,
                                child: CachedNetworkImage(
                                  imageUrl: item.itemImageUrl,
                                  fit: BoxFit.fitWidth,
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: item.equipped == true
                                    ? StyledText(
                                        item.itemName,
                                        fontWeight: 500,
                                        color: Color(0xFFBFBFBF).withOpacity(0.5),
                                        overflowEllipsis: true,
                                      )
                                    : StyledText(
                                        item.itemName,
                                        fontWeight: 500,
                                        color: Color(0xFFBFBFBF),
                                        overflowEllipsis: true,
                                      ),
                              ),
                              item.equipped == false
                                  ? InkWell(
                                      onTap: () => controller.fetchEquipItem(item.id),
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
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 3),
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: const Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: StyledText(
                                            '장착',
                                            fontWeight: 500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
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
                                          child: StyledText('장착중', fontWeight: 500, fontSize: 14, color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 7,
                          top: 7,
                          child: CircleAvatar(
                            backgroundColor: getItemGradeColor(item.itemGrade),
                            radius: 10,
                            child: StyledText(
                              item.itemGrade![0],
                              fontWeight: 600,
                              fontFamily: 'Montserrat',
                              color: item.itemGrade == 'POOR' ? Color(0xFFffffff).withOpacity(0.6) : Color(0xFF000000).withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    InventoryHomeController _controller = Get.find();
    InventoryController inventoryController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xFF363841),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Container(
              height: 28,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _controller.subTabController,
                  isScrollable: false,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF898B92),
                  labelPadding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 6.0, bottom: 3.0),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    color: const Color(0xFFECECEC),
                  ),
                  tabs: [...renderItemSubTabList(_controller)],
                ),
              ),
            ),
          ),
          Obx(() {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller.subTabController,
                  children: [
                    ...renderItemList(_controller, inventoryController, width, height),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
