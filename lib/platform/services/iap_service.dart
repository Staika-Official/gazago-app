
import 'package:gaza_go/platform/apis/iap.dart';
import 'package:dio/dio.dart';
import 'package:gaza_go/platform/models/iap_valid_model.dart';

class IapService {

  static Future<IapValidModel> validateReceipt(data) async {
    Response res = await IapApi.validateReceipt(data);
    return IapValidModel.fromJson(res.data);
  }

}
