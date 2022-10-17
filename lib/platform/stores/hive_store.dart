import 'package:gaza_go/platform/models/user_exercise_model.dart';
import 'package:hive/hive.dart';

class HiveStore {
  static Future<void> openBox() async {
    await Hive.openBox('gazaGo');
  }

  static void save({required String key, required String value}) {
    final Box box = Hive.box('gazaGo');
    box.put(key, value);
  }

  static void saveExerciseData({required UserExerciseModel exerciseData}) {
    final Box box = Hive.box('gazaGo');
    box.put('exerciseData', exerciseData);
  }

  static String? loadString({required String key}) {
    final Box box = Hive.box('gazaGo');
    String? loadData = box.get(key);
    return loadData;
  }

  static UserExerciseModel? loadExerciseData() {
    final Box box = Hive.box('gazaGo');
    UserExerciseModel? loadData = box.get('exerciseData');
    return loadData;
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
