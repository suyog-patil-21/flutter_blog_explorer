import 'package:flutter_blog_explorer/src/logic/service/hive_service/hive_keys_constants.dart';
import 'package:hive/hive.dart';

/// Before using the HiveService
/// configHive() in the utils folder must be set in main function
class HiveService {
  static final HiveService _instance = HiveService._internal();

  HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  Future<Box?> getHiveBoxRefernce<E>(HiveBoxKeysConstants boxName) async {
    try {
      final bool boxExist = await Hive.boxExists(boxName.name);
      if (!boxExist) return null;
      if (Hive.isBoxOpen(boxName.name)) {
        return Hive.box<E>(boxName.name);
      } else {
        return await Hive.openBox<E>(boxName.name);
      }
    } catch (err, errStack) {
      print(
          'Error in HiveServie getHiveBoxRefernce $err\nErrorStack:$errStack');
    }
    return null;
  }

  Future<void> putData(
      HiveBoxKeysConstants boxName, String key, var data) async {
    try {
      final Box? box = await getHiveBoxRefernce(boxName);
      await box?.put(key, data);
    } catch (err, errStack) {
      print('Error in HiveServie putData $err\nErrorStack:$errStack');
    }
  }

  Future<dynamic> getData(HiveBoxKeysConstants boxName, String key) async {
    try {
      final Box? box = await getHiveBoxRefernce(boxName);
      return box?.get(key);
    } catch (err, errStack) {
      print('Error in HiveServie getData $err\nErrorStack:$errStack');
    }
    return null;
  }

  Future<void> deleteKeyValue(HiveBoxKeysConstants boxName, String key) async {
    try {
      final Box? box = await getHiveBoxRefernce(boxName);
      box?.delete(key);
    } catch (err, errStack) {
      print('Error in HiveServie deleteKeyValue $err\nErrorStack:$errStack');
    }
  }

  Future<void> clearBox(HiveBoxKeysConstants boxName) async {
    try {
      final Box? box = await getHiveBoxRefernce(boxName);
      await box?.clear();
    } catch (err, errStack) {
      print('Error in HiveServie clearBox $err\nErrorStack:$errStack');
    }
  }

  Future<void> closeBox(HiveBoxKeysConstants boxName) async {
    try {
      final Box? box = await getHiveBoxRefernce(boxName);
      await box?.close();
    } catch (err, errStack) {
      print('Error in HiveServie clearBox $err\nErrorStack:$errStack');
    }
  }

  Future<void> closeAllBox() async {
    try {
      await Hive.close();
    } catch (err, errStack) {
      print('Error in HiveServie closeAll $err\nErrorStack:$errStack');
    }
  }
}
