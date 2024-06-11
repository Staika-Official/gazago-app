import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/controllers/wallet_master_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/models/nft_detail_model.dart';
import 'package:gaza_go/platform/models/nft_model.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';
import 'package:gaza_go/presentations/components/alert_ui_list.dart';
import 'package:gaza_go/presentations/views/wallet/confirm_wallet_password.dart';
import 'package:get/get.dart';
import 'package:solana/solana.dart';

class WalletOnChainNftDetailController extends GetxController {
  final LoaderController loaderController = Get.find();
  final WalletMasterController walletMasterController = Get.find();

  final Rxn<NftDetailModel> nftDetail = Rxn(null);
  final Rxn<NftModel> _nftItem = Rxn(null);

  @override
  void onInit() async {
    _nftItem.value = Get.arguments['nftItem'];
    super.onInit();
  }

  @override
  void onReady() async {
    getNftDetail();
    super.onReady();
  }

  void getNftDetail() async {
    loaderController.isLoading.value = true;
    await WalletService.getNftDetail(_nftItem.value!.mintAddress!, successCallback: (itemDetail) {
      nftDetail.value = itemDetail;
    }, errorCallback: (e) {
      showToastPopup(e.errorMessage ?? 'Error');
    });
    loaderController.isLoading.value = false;
  }

  void showRequestSendNftDialog() {
    if (nftDetail.value!.belongTo == 'GAZAGO') {
      showSendNftToGoWalletAlert(this);
    } else {
      showNotCompatibleItemAlert(this);
    }
  }

  void requestSendNft() async {
    Get.back();
    loaderController.isLoading.value = true;
    String secretKey = HiveStore.load(key: HiveKey.solanaSecretKey.name);
    String password = await showConfirmPasswordDialog(walletMasterController);
    late final Ed25519HDPublicKey solanaTokenMasterWallet;
    await WalletService.getWalletAddress(
      'SOLANA_GAZAGO_WALLET',
      successCallback: (address) {
        solanaTokenMasterWallet = Ed25519HDPublicKey.fromBase58(address[0].value);
      },
    );

    await WalletService.transferNftToGoWallet(
      accountSecretkey: secretKey,
      walletPassword: password,
      toAddress: solanaTokenMasterWallet,
      mintAddress: nftDetail.value!.mint!.address!,
      successCallback: () {
        loaderController.isLoading.value = false;
        showNftTransferSuccess(isOnChain: true);
      },
      errorCallback: (ErrorResponseDataModel error) {
        loaderController.isLoading.value = false;
        if (error.status == 520) {
          showBlockchainNetworkErrorAlert();
        }
      },
    );
  }
}
