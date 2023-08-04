import 'package:dio/dio.dart';
import 'package:gaza_go/platform/apis/iap.dart';
import 'package:gaza_go/platform/models/iap_pay_model.dart';
import 'package:gaza_go/platform/models/iap_valid_model.dart';

class IapService {
  static Future<IapValidModel> validateReceipt(data) async {
    Response res = await IapApi.validateReceipt(data);
    if (res.statusCode == 201) {
      return IapValidModel.fromJson(res.data);
    } else {
      return IapValidModel(valid: false, state: '');
    }
  }

  static Future<IapPayModel> pay(data) async {
    Response res = await IapApi.pay(data);
    return IapPayModel.fromJson(res.data);
  }
}
