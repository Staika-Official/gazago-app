import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:gaza_go/presentations/views/wallet/go_wallet.dart';
import 'package:gaza_go/presentations/views/wallet/staika_wallet.dart';

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
      backgroundColor: subBg01Color,
      titleText: '지갑',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Color(0xff0E0E0F),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: TabBar(
                controller: _tabController,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                indicator: BoxDecoration(
                  color: popupBgColor,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                indicatorPadding: EdgeInsets.only(bottom: 2),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFFA5A5A5),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: 20 / 18,
                  letterSpacing: 0.5,
                ),
                tabs: [
                  Tab(
                    text: 'GO 지갑',
                  ),
                  Tab(
                    text: 'Staika 지갑',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                GoWallet(),
                StaikaWallet(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
