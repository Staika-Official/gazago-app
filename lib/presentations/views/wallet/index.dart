import 'package:flutter/material.dart';
import 'package:gaza_go/presentations/components/default_container.dart';
import 'package:gaza_go/presentations/styles/styled_text.dart';
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
    _tabController = TabController(vsync: this, length: 1, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      titleText: _tabController.index == 0 ? 'GO 지갑' : '지갑',
      // child: Column(
      //   children: [
      //     SizedBox(
      //       width: double.infinity,
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text('디지털 자산'),
      //           Row(
      //             children: [
      //               Icon(Icons.change_circle),
      //               Padding(
      //                 padding: const EdgeInsets.only(left: 8.0),
      //                 child: Text('KRW'),
      //               )
      //             ],
      //           )
      //         ],
      //       ),
      //     ),
      //     SpendingWallet(),
      //   ],
      // ),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 28),
          //   child: Container(
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.black,
          //       border: Border.all(
          //         color: Color(0xff2a2b33),
          //         width: 2,
          //       ),
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     child: TabBar(
          //       controller: _tabController,
          //       padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
          //       indicator: BoxDecoration(
          //         color: Color(0xff2A2B33),
          //         borderRadius: BorderRadius.circular(50),
          //       ),
          //       labelColor: Colors.white,
          //       unselectedLabelColor: Color(0xffcccccc),
          //       labelStyle: TextStyle(
          //         fontWeight: FontWeight.w500,
          //         fontSize: 18,
          //         height: 20 / 18,
          //         letterSpacing: 0.5,
          //       ),
          //       tabs: [
          //         Tab(
          //           text: 'gazaGO 지갑',
          //         ),
          //         Tab(
          //           text: 'Staika 지갑',
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 33, right: 33, top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledText(
                    '디지털 자산',
                    fontSize: 16,
                    fontWeight: 600,
                    lineHeight: 20,
                    letterSpacing: -0.5,
                  ),
                  // Row(
                  //   children: [
                  //     SvgPicture.asset('assets/images/wallet/ico_change.svg'),
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 6.0),
                  //       child: Text(
                  //         'KRW',
                  //         style: TextStyle(
                  //           fontSize: 10,
                  //           color: Color(0xffA5A5A5),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SpendingWallet(),
                // AssetWallet(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
