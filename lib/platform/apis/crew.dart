import 'package:dio/dio.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/crew_create_form_model.dart';

class CrewApi {
  static Future<Response> createCrew(String userId, CrewCreateFormModel formData) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).post('/crews/users/$userId', data: {
      "name": formData.name,
      "userId": userId,
      "challengeId": formData.challengeId,
      "crewIconId": formData.crewIconId,
      "crewCreateType": formData.crewCreateType,
      "price": formData.price,
    });
  }

  static Future<Response> joinCrew(String userId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).post('/user-crews/users/$userId', data: {
      "crewId": "크루명",
      "userId": 1,
      "challengeId": 2,
    });
  }

  static Future<Response> getCrewMarkIcons() async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/crew-icons');
  }
}
