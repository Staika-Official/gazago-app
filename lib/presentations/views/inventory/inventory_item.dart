import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_home_controller.dart';
import 'package:gaza_go/platform/helpers/inventory_helper.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
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
            physics: const ScrollPhysics(),
            primary: false,
            controller: controller.itemScrollController,
            padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
            childAspectRatio: (1 / 1.4),
            crossAxisSpacing: 10.sp,
            mainAxisSpacing: 10.sp,
            crossAxisCount: (width < 350.sp) ? 2 : 3,
            children: [
              ...controller.allItems[tab['itemType']]!.map(
                (item) => InkWell(
                  onTap: () => controller.toItemDetail(item.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: subBg01Color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.sp),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.sp, horizontal: 15.0.sp),
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
                                padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp),
                                child: item.equipped == true
                                    ? StyledText(
                                        item.itemName,
                                        fontWeight: 500,
                                        color: lightGrayColor.withOpacity(0.5),
                                        overflowEllipsis: true,
                                      )
                                    : StyledText(
                                        item.itemName,
                                        fontWeight: 500,
                                        color: lightGrayColor,
                                        overflowEllipsis: true,
                                      ),
                              ),
                              item.equipped == false
                                  ? InkWell(
                                      onTap: () => controller.fetchEquipItem(item.id),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: popupBgColor,
                                          border: Border.all(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color: const Color(0xFF54F5FF),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.sp),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 3.sp),
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: const StyledText(
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
                                          color: popupBgColor,
                                          border: Border.all(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color: deepGrayColor,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.sp),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 3.sp),
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: StyledText('장착중', fontWeight: 500, fontSize: 14, color: deepGrayColor),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 7.sp,
                          top: 7.sp,
                          child: CircleAvatar(
                            backgroundColor: getItemGradeColor(item.itemGrade),
                            radius: 10.sp,
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
      color: popupBgColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 20.0.sp),
            child: Container(
              height: 28.sp,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _controller.subTabController,
                  isScrollable: true,
                  labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFF898B92),
                  labelPadding: EdgeInsets.only(left: 14.0.sp, right: 14.0.sp, top: 6.0.sp, bottom: 3.0.sp),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0.sp),
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
                padding: EdgeInsets.only(top: 5.0.sp, bottom: 15.sp),
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
