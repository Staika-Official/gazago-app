import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/constants/routes.dart';
import 'package:gaza_go/platform/controllers/loading_controller.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/asset_detail_model.dart';
import 'package:gaza_go/platform/models/asset_token_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_detail_balance_model.dart';
import 'package:gaza_go/platform/models/asset_token_transaction_model.dart';
import 'package:gaza_go/platform/models/buy_tik_response_model.dart';
import 'package:gaza_go/platform/models/iap_valid_model.dart';
import 'package:gaza_go/platform/models/pay_info_model.dart';
import 'package:gaza_go/platform/models/token_info_model.dart';
import 'package:gaza_go/platform/models/user_account_model.dart';
import 'package:gaza_go/platform/services/iap_service.dart';
import 'package:gaza_go/platform/services/uaa_service.dart';
import 'package:gaza_go/platform/services/wallet_service.dart';
import 'package:gaza_go/presentations/components/gazago_button.dart';
import 'package:gaza_go/presentations/components/product_list_dialog.dart';
import 'package:gaza_go/presentations/styles/colors.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class WalletMasterController extends GetxController {
  final RxList<AssetTokenBalanceModel> spendingTokens = RxList.empty();
  final RxList<TokenInfoModel> spendingTokenInfoList = RxList.empty();
  final Rx<AssetTokenBalanceModel> selectedAsset = Rx(AssetTokenBalanceModel());
  final Rx<AssetDetailModel> assetDetail = Rx(AssetDetailModel(balance: AssetTokenDetailBalanceModel(), transactions: []));
  final Rx<AssetTokenBalanceModel> buyTikCommission = Rx(AssetTokenBalanceModel());
  final RxString buyTikAmount = RxString('0');
  final Rx<BuyTikResponseModel> buyTikResult = Rx(BuyTikResponseModel());
  final RxInt feeTikStamina = RxInt(0);
  final RxInt feeTikDurability = RxInt(0);
  final ScrollController transactionScrollController = ScrollController();
  final RxDouble transactionScrollPosition = RxDouble(0);
  final GlobalKey webViewKey = GlobalKey();

  StreamSubscription<List<PurchaseDetails>>? subscription;
  final RxBool storeUnavailable = RxBool(false);
  final RxBool showPendingPurchaseUI = RxBool(false);
  final RxList<ProductDetails> inAppProducts = RxList.empty();

  RxList<AssetTokenBalanceModel> get spendingTokenUiList {
    List<AssetTokenBalanceModel> balanceUiList = List.empty(growable: true);

    for (AssetTokenBalanceModel token in spendingTokens) {
      AssetTokenBalanceModel tokenUi;
      if (['STIK', 'TOTAL_TIK'].any((symbol) => symbol == token.symbol)) {
        tokenUi = token;
        balanceUiList.add(tokenUi);
      }
    }

    return RxList(balanceUiList);
  }

  Rx<AssetTokenBalanceModel> get tik {
    return Rx(spendingTokenUiList.singleWhere((token) => token.symbol == 'TOTAL_TIK', orElse: () {
      showToastPopup('TAIKA를 찾을 수 없습니다.');
      return AssetTokenBalanceModel();
    }));
  }

  Rx<AssetTokenBalanceModel> get stik {
    return Rx(spendingTokenUiList.singleWhere((token) => token.symbol == 'STIK', orElse: () {
      showToastPopup('STAIKA를 찾을 수 없습니다.');
      return AssetTokenBalanceModel();
    }));
  }

  RxList<AssetTokenTransactionModel> get transactionsList {
    List<AssetTokenTransactionModel> transactionsList = List.empty(growable: true);

    List<AssetTokenTransactionModel> rawList = assetDetail.value.transactions;
    if (rawList.isNotEmpty) {
      int id = rawList.first.transactionId!;
      List<List<AssetTokenTransactionModel>> listsById = List.empty(growable: true);
      List<AssetTokenTransactionModel> tempList = List.empty(growable: true);
      for (AssetTokenTransactionModel transaction in rawList) {
        print(transaction.transactionId);
        if (id != transaction.transactionId) {
          id = transaction.transactionId!;
          listsById.add(tempList);
          tempList = List.empty(growable: true);
        }

        tempList.add(transaction);

        if (id == rawList.last.transactionId) {
          listsById.add(tempList);
        }
      }

      for (List<AssetTokenTransactionModel> listById in listsById) {
        List<AssetTokenTransactionModel> outList = List.empty(growable: true);
        for (AssetTokenTransactionModel transaction in listById) {
          if (transaction.type == 'FEE') {
            transactionsList.add(transaction);
          } else {
            outList.add(transaction);
          }
        }

        if (outList.length > 1) {
          AssetTokenTransactionModel totalOutTransaction = outList.reduce((value, element) {
            AssetTokenTransactionModel reduceTransaction;
            reduceTransaction = AssetTokenTransactionModel.fromJson(value.toJson());
            reduceTransaction.symbol = 'TIK';
            reduceTransaction.amount = value.amount! + element.amount!;
            reduceTransaction.uiAmountString = (double.parse(value.uiAmountString!) + double.parse(element.uiAmountString!)).toString();
            return reduceTransaction;
          });

          transactionsList.add(totalOutTransaction);
        } else {
          transactionsList.add(outList.first);
        }
      }
    }

    return RxList(transactionsList);
  }

  @override
  onInit() {
    initInAppPurchaseStream();
    connectToStores();
    super.onInit();
  }

  Future<void> initializeController() async {
    await getSpendingWalletBalances();
    transactionScrollController.addListener(() {
      transactionScrollPosition.value = transactionScrollController.position.pixels;
    });

    onInit();
  }

  Future<void> getSpendingWalletBalances() async {
    await WalletService.getSpendingWalletBalances(successCallback: (balances) {
      spendingTokens.value = balances;
    });

    if (Get.isRegistered<LoadingController>()) Get.find<LoadingController>().updateProgress("서비스를 위해 정보를 불러오는 중입니다.");
  }

  Future<void> getSpendingWalletTransactions(AssetTokenBalanceModel asset) async {
    selectedAsset.value = asset;
    assetDetail.value = await WalletService.getSpendingWalletTransactions(asset.symbol!);
  }

  Future<void> buyTik(int tikAmount) async {
    buyTikResult.value = await WalletService.buyTik(tikAmount);
    await getSpendingWalletBalances();
    showToastPopup('$tikAmount TIK이 충전되었습니다.');
    Get.until((route) => route.settings.name == Routes.wallet);
  }

  Future<void> payWithToken(PayInfoModel payInfo) async {
    await WalletService.payWithToken(payInfo);
  }

  Future<void> getFeeTik() async {
    await WalletService.getFeeTik(
      successCallback: (fees) {
        feeTikStamina.value = fees['FEE_TIK_STAT_RECOVERY'];
        feeTikDurability.value = fees['FEE_TIK_ITEM_REPAIR'];
      },
    );
  }

  void moveToWalletDetail({required AssetTokenBalanceModel asset, required WalletType walletType, required AssetType assetType}) async {
    await getSpendingWalletTransactions(asset);
    transactionScrollPosition.value = 0;
    Get.toNamed(Routes.walletDetail, arguments: {'asset': asset, 'walletType': walletType, 'assetType': assetType});
  }

  void toBuyTik() {
    Get.toNamed(Routes.buyTik);
    buyTikAmount.value = '0';
    // buyTikAmountController.text = buyTikAmount.value;
  }

  void enterBuyTikAmount(String tikAmount) {
    // buyTikAmountController.text = tikAmount;
    buyTikAmount.value = tikAmount;
  }

  void showBuyConfirmation(Widget confirmationBottomSheet) {
    Get.bottomSheet(
      confirmationBottomSheet,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  void onClickMoveToTaikaPay() async {
    await UaaService.getAccountInfo(
      successCallback: (UserAccountModel user) {
        if (user.authorities!.contains('ROLE_CERTIFIED_USER')) {
          Get.toNamed(Routes.taikaPay);
        } else {
          showAlert(
            title: '본인인증이 필요합니다.',
            contentText: '상품권 교환을 위해서는 본인인증이 필요하여\n인증페이지로 이동합니다.',
            actions: [
              Expanded(
                child: GazagoButton(
                  onTap: () => moveToTaikaPay(),
                  buttonText: '확인',
                  buttonColor: skyBlueColor,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void moveToTaikaPay() async {
    Get.back();
    Get.toNamed(Routes.verificationTerms);
  }

  void moveToWallet() async {
    getSpendingWalletBalances();
    Get.toNamed(Routes.wallet);
  }

  void initInAppPurchaseStream() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
    subscription ??= purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription!.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingPurchaseUI.value = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handlePurchaseError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _completePurchaseInAppItem(purchaseDetails);
        }
      }
    });
  }

  void connectToStores() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      storeUnavailable.value = true;
    } else {
      Set<String> _kIds = Platform.isIOS ? <String>{'ptik_purchase', 'ptik_purchase_test'} : <String>{'ptik_purchase_1', 'ptik_purchase_1000'};
      final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        showToastPopup('구매할 수 있는 상품을 찾지 못했습니다.');
      }
      inAppProducts.value = response.productDetails;
    }
  }

  void showProductDialog() {
    showProductList(this);
  }

  void purchaseInAppItem(ProductDetails product) {
    InAppPurchase.instance.buyConsumable(purchaseParam: PurchaseParam(productDetails: product));
  }

  void _handlePurchaseError(IAPError error) {
    showPendingPurchaseUI.value = false;
    showToastPopup('구매에 실패했습니다.\n잠시후 다시 요청해주세요');
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.

    IapValidModel response = await IapService.validateReceipt({});

    // 백앤드 검증
    print('#################################################');
    print('purchaseDetails.productID : ${purchaseDetails.productID}');
    print('purchaseDetails.purchaseID : ${purchaseDetails.purchaseID}');
    inspect(purchaseDetails);

    print('#################################################');
    return Future<bool>.value(response.valid);
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    showPendingPurchaseUI.value = false;
    showToastPopup('타이카 구매 요청!!!!!!');
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    showPendingPurchaseUI.value = false;
    showToastPopup('구매할 수 없는 상품입니다.');
  }

  Future<void> _completePurchaseInAppItem(PurchaseDetails purchaseDetails) async {
    showPendingPurchaseUI.value = false;

    await InAppPurchase.instance.completePurchase(purchaseDetails);
    Get.until((route) => Get.isDialogOpen == false);
    showToastPopup('구매가 완료되었습니다.');
    getSpendingWalletBalances();
  }
}
