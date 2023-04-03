import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/helpers/wallet_mixin.dart';
import 'package:gaza_go/platform/models/asset_item_nft_model.dart';
import 'package:gaza_go/platform/models/dummy_token_model.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:get/get.dart';

class StaikaWalletController extends GetxController with WalletMixin {
  final RxList<DummyTokenModel> coinAssetList = RxList.empty();
  final RxList<AssetItemNftModel> nftAssetList = RxList.empty();
  final RxString userWalletAddress = RxString('');
  final Rxn<AnimationController> switchAnimation = Rxn();
  final Rx<Currency> currency = Rx(Currency.krw);

  RxBool get isKRW {
    return RxBool(currency.value.name == 'krw');
  }

  @override
  void onInit() async {
    await getStaikaWalletInfo();
    super.onInit();
  }

  Future<void> getStaikaWalletInfo() async {
    await WalletService.getOnChainWallet(
      successCallback: (data) {
        print(data);
        userWalletAddress.value = data.publicKey;
        showStaikaStatusAlert(hasWallet: true);
      },
      errorCallback: (ErrorResponseDataModel data) {
        if (data.errorCode == 'WalletNotFoundException') {
          TabController controller = Get.find<WalletMasterController>().tabController;
          showStaikaStatusAlert(hasWallet: false, tabController: controller);
        } else if (data.errorCode == 'DatabaseErrorException') {
          showToastPopup('잠시 후 다시 시도해 주세요');
        }
      },
    );
  }

  void getAssetList() {
    coinAssetList.value = [
      DummyTokenModel(name: 'solana', balance: 100.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'staika', balance: 10.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      DummyTokenModel(name: 'taika', balance: 1000.00, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];

    nftAssetList.value = [
      AssetItemNftModel(name: 'LV.1 만월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemNftModel(name: 'LV.1 소월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
      AssetItemNftModel(name: 'LV.1 대월산 등정 뱃지', balance: 1, tokenImageUrl: 'https://placeimg.com/20/20/any'),
    ];
  }

  void handleCopyWalletAddress() async {
    await Clipboard.setData(ClipboardData(text: userWalletAddress.value));
    showToastPopup('주소가 복사 되었습니다.');
  }

  void onOpenSolScanWallet() {
    Get.toNamed(Routes.webView, arguments: {'linkUrl': 'https://solscan.io/account/${userWalletAddress}'});
  }

  void setSwitchValue(bool value) {
    currency.value = value ? Currency.krw : Currency.usd;
    // _localSaveUseCase.saveDisplayCurrency(currency: currency.value);
    switchAnimation.value?.reset();
    switchAnimation.value?.forward();
  }
}
