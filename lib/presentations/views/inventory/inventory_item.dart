import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
import 'package:get/get.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController _controller = Get.put(InventoryHomeController());
    InventoryController inventoryController = Get.find();
    return Container(
      color: Color(0xFF363841),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _controller.subTabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  color: Color(0xFFECECEC),
                ),
                tabs: [
                  Tab(
                    child: StyledText(
                      '모자',
                    ),
                  ),
                  Tab(
                    child: StyledText(
                      '상의',
                    ),
                  ),
                  Tab(
                    child: StyledText(
                      '하의',
                    ),
                  ),
                  Tab(
                    child: StyledText(
                      '신발',
                    ),
                  ),
                  Tab(
                    child: StyledText(
                      '액세서리',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            return Expanded(
              child: TabBarView(
                controller: _controller.subTabController,
                children: [
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: [
                      ...inventoryController.allItems['hats']!.map(
                        (hat) => InkWell(
                          onTap: () => inventoryController.toItemDetail(hat.id),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CachedNetworkImage(
                                imageUrl: hat.itemImageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(hat.itemName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: <Widget>[
                      ...inventoryController.allItems['outers']!.map(
                        (outer) => InkWell(
                          onTap: () => inventoryController.toItemDetail(outer.id),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CachedNetworkImage(
                                imageUrl: outer.itemImageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(outer.itemName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: <Widget>[
                      ...inventoryController.allItems['bottoms']!.map(
                        (bottom) => InkWell(
                          onTap: () => inventoryController.toItemDetail(bottom.id),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CachedNetworkImage(
                                imageUrl: bottom.itemImageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(bottom.itemName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: <Widget>[
                      ...inventoryController.allItems['shoes']!.map(
                        (shoe) => InkWell(
                          onTap: () => inventoryController.toItemDetail(shoe.id),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CachedNetworkImage(
                                imageUrl: shoe.itemImageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(shoe.itemName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: <Widget>[
                      ...inventoryController.allItems['accessories']!.map(
                        (accessory) => InkWell(
                          onTap: () => inventoryController.toItemDetail(accessory.id),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CachedNetworkImage(
                                imageUrl: accessory.itemImageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Image.asset("assets/images/@temp_badge.png"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(accessory.itemName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
