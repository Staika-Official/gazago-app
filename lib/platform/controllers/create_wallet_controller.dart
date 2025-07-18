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
    safeCreateWallet(1);
  }

  @override
  void onClose() {}

  Future<OnChainWalletModel?> createWallet() async {
    OnChainWalletModel? wallet;
    await WalletService.createOnChainWallet(
      walletPassword: Get.arguments['password'],
      successCallback: (OnChainWalletModel onChainWallet) {
        wallet = onChainWallet;
      },
      errorCallback: () {
        walletCreationFailed();
      },
    );
    return wallet;
  }

  Future<bool> keyIsValid() async {
    return await WalletService.encryptionIsValid(
      walletPassword: Get.arguments['password'],
    );
  }

  Future<void> disableWallet() async {
    await WalletService.disableOnChainWallet(successCallback: () {}, errorCallback: (e) {});
  }

  void walletCreationFailed() {
    isCreationSuccessful.value = false;
    isCreatingWallet.value = false;
  }

  Future<void> safeCreateWallet(int retryAttempt) async {
    OnChainWalletModel? wallet = await createWallet();
    if (wallet != null) {
      if (retryAttempt < 3) {
        if (await keyIsValid()) {
          // 지갑 생성 완료
          Adjust.trackEvent(AdjustEvent('v2xlbe'));

          HiveStore.save(key: HiveKey.solanaSecretKey.name, value: wallet.secretKey);
          isCreationSuccessful.value = true;
          isCreatingWallet.value = false;
        } else {
          await disableWallet();
          if (retryAttempt == 1) {
            await safeCreateWallet(retryAttempt + 1);
          } else {
            walletCreationFailed();
          }
        }
      } else {
        walletCreationFailed();
      }
    }
  }
}
