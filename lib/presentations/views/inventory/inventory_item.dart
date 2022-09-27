import 'package:flutter/material.dart';
import 'package:gaza_go/platform/controllers/inventory/inventory_home_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:get/get.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController _controller = Get.put(InventoryHomeController());
    InventoryController inventoryController = Get.find();
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TabBar(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            controller: _controller.subTabController,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                child: Text(
                  '모자',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  '상의',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  '하의',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  '신발',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  '액세서리',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
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
                              Image(
                                image: NetworkImage(hat.itemImageUrl),
                                fit: BoxFit.fill,
                                width: double.infinity,
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
                              Image(
                                image: NetworkImage(outer.itemImageUrl),
                                fit: BoxFit.fill,
                                width: double.infinity,
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
                              Image(
                                image: NetworkImage(bottom.itemImageUrl),
                                fit: BoxFit.fill,
                                width: double.infinity,
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
                              Image(
                                image: NetworkImage(shoe.itemImageUrl),
                                fit: BoxFit.fill,
                                width: double.infinity,
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
                              Image(
                                image: NetworkImage(accessory.itemImageUrl),
                                fit: BoxFit.fill,
                                width: double.infinity,
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
