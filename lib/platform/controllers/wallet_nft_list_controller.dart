import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/home_menu_controller.dart';
import 'package:gaza_go/platform/controllers/inventory_controller.dart';
import 'package:gaza_go/platform/controllers/loader_controller.dart';
import 'package:gaza_go/platform/events/index.dart';
import 'package:gaza_go/platform/events/replay_event_bus.dart';
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
  final RxBool isLoadingInProgress = RxBool(false);

  @override
  void onReady() async {
    isFromGoWallet.value = Get.arguments['prevRoute'] == 'GO_WALLET';
    if (isFromGoWallet.value) {
      await getNftList();
    } else {
      await getOnChainNftList();
    }

    Get.bus.on<RefreshNftListEvent>((event) async {
      if (isFromGoWallet.value) {
        await getNftList();
      } else {
        await getOnChainNftList();
      }
    });
    super.onReady();
  }

  void moveToShop() {
    ReplayEventBus.instance.addEvent(BuyNftEvent());
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
    loaderController.isLoading.value = true;
    isLoadingInProgress.value = true;
    await ItemService.getAllMyItems(
      0,
      publishType: 'NFT',
      successCallback: (List<InventoryItemModel> nftItems, int totalItemCount) {
        this.totalItemCount.value = totalItemCount;
        if (nftItems.length < 100) {
          stopLoading.value = true;
        }
        if (nftList.isNotEmpty) nftList.clear();
        nftList.addAll(nftItems);
      },
    );
    loaderController.isLoading.value = false;
    isLoadingInProgress.value = false;
  }

  Future<void> getOnChainNftList() async {
    loaderController.isLoading.value = true;
    isLoadingInProgress.value = true;
    await WalletService.getNftList(successCallback: (list) {
      if (onChainNftList.isNotEmpty) onChainNftList.clear();
      onChainNftList.addAll(list);
    }, errorCallback: (e) {
      showToastPopup(e.errorMessage ?? 'Error');
    });
    loaderController.isLoading.value = false;
    isLoadingInProgress.value = false;
  }

  void toItemDetail(int itemId) {
    InventoryController controller = Get.put(InventoryController());
    controller.toItemDetail(itemId, prevRoute: Routes.walletNftList);
  }
}
