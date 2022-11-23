import 'package:gaza_go/constants/enums.dart';
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
    box.put(key, value);
  }

  static void saveUserExerciseData({required dynamic value}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.userExerciseDataLogs.name, value);
  }

  static void savePositionLowData({required dynamic value}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.positionLowDataLogs.name, value);
  }

  static void saveCurrentUserState({required CurrentUserStateModel userState}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.userState.name, userState);
  }

  static void saveExerciseData({required UserExerciseModel exerciseData}) {
    final Box box = Hive.box('gazaGo');
    box.put(HiveKey.exerciseData.name, exerciseData);
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

  static UserExerciseModel? loadExerciseData() {
    final Box box = Hive.box('gazaGo');
    return box.get(HiveKey.exerciseData.name);
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
}
