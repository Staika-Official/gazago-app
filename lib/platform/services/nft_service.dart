import 'package:dio/dio.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/apis/nft.dart';
import 'package:gaza_go/platform/models/error_response_data_model.dart';
import 'package:gaza_go/platform/stores/hive_store.dart';

class NftService {
  static String? get userId {
    return HiveStore.loadString(key: HiveKey.userId.name);
  }

  static Future<void> requestTransferNftToStaika({required int nftId, required int userItemId, bool showLoading = false, required Function successCallback, Function? errorCallback}) async {
    Response res = await NftApi.transferNftToStaika(userId: userId!, nftId: nftId, userItemId: userItemId, showLoading: showLoading);
    if (res.statusCode == 204) {
      successCallback();
    } else {
      if (errorCallback != null) errorCallback(ErrorResponseDataModel.fromJson(res.data));
    }
  }
}
