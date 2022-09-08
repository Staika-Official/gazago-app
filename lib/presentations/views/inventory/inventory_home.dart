import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:step_go/platform/controllers/inventory/inventory_home_controller.dart';
import 'package:step_go/presentations/components/default_container.dart';
import 'package:step_go/presentations/views/inventory/inventory_badge.dart';
import 'package:step_go/presentations/views/inventory/inventory_item.dart';

class InventoryHome extends StatelessWidget {
  InventoryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InventoryHomeController _controller = Get.put(InventoryHomeController());

    return DefaultContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Column(
                children: [
                  Text('[장착 중인 아이템]'),
                  StaggeredGrid.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: Tile(index: 0),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 2,
                        mainAxisCellCount: 2,
                        child: Tile(index: 1),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Tile(index: 2),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Tile(index: 3),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Tile(index: 4),
                      ),
                      StaggeredGridTile.count(
                        crossAxisCellCount: 1,
                        mainAxisCellCount: 1,
                        child: Tile(index: 5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('asd'),
                  LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: const Color(''),
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _controller.tabController,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    '메뉴1',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    '메뉴2',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _controller.tabController,
                children: [
                  InventoryItem(),
                  InventoryBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _defaultColor = Color(0xFF34568B);

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? _defaultColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
