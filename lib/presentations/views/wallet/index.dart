import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/views/wallet/asset_wallet.dart';
import 'package:gaza_go/presentations/views/wallet/spending_wallet.dart';

class WalletHome extends StatefulWidget {
  const WalletHome({Key? key}) : super(key: key);

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
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
              controller: _tabController,
              children: [
                SpendingWallet(),
                AssetWallet(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
