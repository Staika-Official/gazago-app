import 'package:dio/dio.dart';
import 'package:gaza_go/platform/middleware/dio_middleware.dart';
import 'package:gaza_go/platform/models/crew_create_form_model.dart';

class CrewApi {
  static Future<Response> createCrew(String userId, CrewCreateFormModel formData) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
      allowCustomErrorHandler: true,
    ).post('/crews/users/$userId', data: {
      "name": formData.name,
      "userId": userId,
      "challengeId": formData.challengeId,
      "crewIconId": formData.crewIconId,
      "crewCreateType": formData.crewCreateType,
      "price": formData.price,
    });
  }

  static Future<Response> joinCrew(String userId, int challengeId, int crewId) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
      allowCustomErrorHandler: true,
    ).post('/user-crews/users/$userId', data: {
      "crewId": crewId,
      "userId": userId,
      "challengeId": challengeId,
    });
  }

  static Future<Response> getCrewMarkIcons() async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/crew-icons');
  }

  static Future<Response> changeRecruitStatus(String userId, int crewId, String recruitStatus) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
      allowCustomErrorHandler: true,
    ).post('/crews/$crewId/users/$userId/recruit-status/$recruitStatus', data: {
      "crewId": crewId,
      "userId": userId,
      "crewRecruitStatus": recruitStatus,
    });
  }

  static Future<Response> getDailyBlockCount(
    String userId,
    int crewId,
  ) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
    ).get('/crews/$crewId/users/$userId/daily-blocks');
  }

  static Future<Response> joinCompanyCrew(String userId, int challengeId, String employeeId, String employeeName) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
      allowCustomErrorHandler: true,
    ).post('/user-crews/users/$userId', data: {
      "employeeId": employeeId,
      "employeeName": employeeName,
      "userId": userId,
      "challengeId": challengeId,
    });
  }

  static Future<Response> checkAvailableCompanyCrewChallenge(String userId, int challengeId, String employeeId, String employeeName) async {
    return await Api.client(
      serviceUrl: '/services/gazago/api',
      showLoading: false,
      allowCustomErrorHandler: true,
    ).get('/companies/users/${userId}/challenges/${challengeId}/join-available', queryParameters: {
      "employeeId": employeeId,
      "employeeName": employeeName,
    });
  }
}
