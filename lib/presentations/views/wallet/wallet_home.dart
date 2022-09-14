import 'package:flutter/material.dart';
import 'package:step_go/presentations/components/default_header.dart';
import 'package:step_go/presentations/views/wallet/wallet_assets.dart';
import 'package:step_go/presentations/views/wallet/wallet_inventory.dart';

class WalletHome extends StatelessWidget {
  const WalletHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: DefaultHeader(),
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: '인벤토리',
                ),
                Tab(
                  text: '지갑',
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('디지털 자산'),
                  Row(
                    children: [
                      Icon(Icons.change_circle),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('KRW'),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  WalletInventory(),
                  WalletAssets(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
