import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/inventory/inventory_home_controller.dart';

class InventoryItem extends StatelessWidget {
  const InventoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController _controller = Get.put(InventoryHomeController());
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TabBar(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            controller: _controller.subTabController,
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
        ],
      ),
    );
  }
}
