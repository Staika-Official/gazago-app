import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/events/index.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/inventory_item_model.dart';
import 'package:gaza_go/platform/models/nft_model.dart';
import 'package:gaza_go/platform/services/item_service.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:get/get.dart';
import 'package:get_event_bus/get_event_bus.dart';

class WalletNftListController extends GetxController {
  final HomeMenuController homeMenuController = Get.find<HomeMenuController>();
  final LoaderController loaderController = Get.find();
  final RxBool isFromGoWallet = RxBool(true);

  final RxList<NftModel> onChainNftList = RxList<NftModel>.empty();
  final RxList<InventoryItemModel> nftList = RxList<InventoryItemModel>.empty();
  final RxInt totalItemCount = RxInt(0);
  final RxBool stopLoading = RxBool(false);

  @override
  void onReady() async {
    isFromGoWallet.value = Get.arguments['prevRoute'] == 'GO_WALLET';
    if (isFromGoWallet.value) {
      loaderController.isLoading.value = true;
      await getNftList();
      loaderController.isLoading.value = false;
    } else {
      loaderController.isLoading.value = true;
      await getOnChainNftList();
      loaderController.isLoading.value = false;
    }

    Get.bus.on<RefreshNftListEvent>((event) async {
      loaderController.isLoading.value = true;
      if (isFromGoWallet.value) {
        nftList.clear();
        await getNftList();
      } else {
        onChainNftList.clear();
        await getOnChainNftList();
      }
      loaderController.isLoading.value = false;
    });
    super.onReady();
  }

  void moveToShop() {
    homeMenuController.selectMenu(3);
    Get.until((route) => Get.currentRoute == Routes.home);
  }

  void moveToItemDetail({int? itemId, NftModel? nftItem}) async {
    if (isFromGoWallet.value) {
      toItemDetail(itemId!);
    } else {
      Get.toNamed(Routes.walletOnChainNftDetail, arguments: {'nftItem': nftItem});
    }
  }

  Future<void> getNftList() async {
    await ItemService.getAllMyItems(
      0,
      publishType: 'NFT',
      successCallback: (List<InventoryItemModel> nftItems, int totalItemCount) {
        this.totalItemCount.value = totalItemCount;
        if (nftItems.length < 100) {
          stopLoading.value = true;
        }
        nftList.addAll(nftItems);
      },
    );
  }

  Future<void> getOnChainNftList() async {
    await WalletService.getNftList(successCallback: (list) {
      onChainNftList.addAll(list);
    }, errorCallback: (e) {
      showToastPopup(e.errorMessage ?? 'Error');
    });
  }

  void toItemDetail(int itemId) {
    InventoryController controller = Get.put(InventoryController());
    controller.toItemDetail(itemId);
  }
}
