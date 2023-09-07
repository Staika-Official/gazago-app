import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/models/on_chain_wallet_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:get/get.dart';

class CreateWalletController extends GetxController {
  final RxBool isCreatingWallet = RxBool(true);
  final RxBool isCreationSuccessful = RxBool(false);

  @override
  void onInit() {
    isCreatingWallet.value = true;
    super.onInit();
  }

  @override
  void onReady() {
    createWallet();
  }

  @override
  void onClose() {}

  void createWallet() async {
    await WalletService.createOnChainWallet(
      walletPassword: Get.arguments['password'],
      successCallback: (OnChainWalletModel onChainWallet) {
        // 지갑 생성 완료
        Adjust.trackEvent(AdjustEvent('v2xlbe'));

        HiveStore.save(key: HiveKey.solanaSecretKey.name, value: onChainWallet.secretKey);
        isCreationSuccessful.value = true;
        isCreatingWallet.value = false;
      },
      errorCallback: () {
        isCreationSuccessful.value = false;
        isCreatingWallet.value = false;
      },
    );
  }
}
