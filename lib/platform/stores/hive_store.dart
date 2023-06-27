import 'dart:io';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:gaza_go/constants/enums.dart';
import 'package:gaza_go/platform/helpers/alert_helper.dart';
import 'package:gaza_go/platform/models/current_user_state_model.dart';
import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:gaza_go/platform/models/user_shoes_model.dart';
import 'package:gaza_go/platform/models/user_state_model.dart';
import 'package:hive/hive.dart';

class HiveStore {
  static void registerAdapters() {
    Hive.registerAdapter(UserExerciseModelAdapter());
    Hive.registerAdapter(UserStateModelAdapter());
    Hive.registerAdapter(UserShoesModelAdapter());
    Hive.registerAdapter(CurrentUserStateModelAdapter());
  }

  static Future<void> openBox() async {
    await Hive.openBox('gazaGo');
  }

  static void save({required String key, required dynamic value}) {
    final Box box = Hive.box('gazaGo');
    box.put(key, value).onError((FileSystemException error, stackTrace) => handleHiveError(error));
  }

  static void saveUserExerciseData({required dynamic value}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.userExerciseDataLogs.name, value).onError((FileSystemException error, stackTrace) => handleHiveError(error));
  }

  static void savePositionRawData({required dynamic value}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.positionRawDataLogs.name, value).onError((FileSystemException error, stackTrace) => handleHiveError(error));
  }

  static void saveCurrentUserState({required CurrentUserStateModel userState}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.userState.name, userState).onError((FileSystemException error, stackTrace) => handleHiveError(error));
  }

  static dynamic load({required String key}) {
    final Box box = Hive.box('gazaGo');
    return box.get(key);
  }

  static String? loadString({required String key}) {
    final Box box = Hive.box('gazaGo');
    return box.get(key);
  }

  static CurrentUserStateModel? loadCurrentUserState() {
    final Box box = Hive.box('gazaGo');
    return box.get(HiveKey.userState.name);
  }

  static void deleteKey({required String key}) {
    final Box box = Hive.box('gazaGo');
    box.delete(key);
  }

  static void deleteMultipleKeys({required List<String> keys}) {
    final Box box = Hive.box('gazaGo');
    box.deleteAll(keys);
  }

  static Future<void> clear() async {
    final Box box = Hive.box('gazaGo');
    await box.clear();
  }

  static void saveExerciseCoordinate(List<LatLng> coordinates) {
    final Box box = Hive.box('gazaGo');
    List<List> untypedCoordinateList = List.empty(growable: true);
    for (LatLng coordinate in coordinates) {
      untypedCoordinateList.add([coordinate.latitude, coordinate.longitude]);
    }

    box.put(HiveKey.lastUpdatedCoordinateIndex.name, coordinates.length).onError((FileSystemException error, stackTrace) => handleHiveError(error));
    box.put(HiveKey.exerciseCoordinates.name, untypedCoordinateList).onError((FileSystemException error, stackTrace) => handleHiveError(error));
  }

  static void initializeExerciseCoordinates() {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.lastUpdatedCoordinateIndex.name, 0).onError((FileSystemException error, stackTrace) => handleHiveError(error));
    box.put(HiveKey.exerciseCoordinates.name, []).onError((FileSystemException error, stackTrace) => handleHiveError(error));
  }

  static void handleHiveError(FileSystemException e) {
    if (e.osError != null && e.osError!.errorCode == 28) {
      showToastPopup('저장공간이 부족합니다.');
    }
  }
}
