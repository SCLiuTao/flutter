import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  // 设置数据的方法
  static Future<void> setString(key, value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);

    // 设置其它数据类型的方法
    // sp.setBool(key, value);
    // sp.setDouble(key, value);
    // sp.setInt(key, value);
    // sp.setStringList(key, value);
  }

  // 获取数据的方法
  static Future<String?> getString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  // 移除数据的方法
  static Future<void> removeString(key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove(key);
  }

  // 移除所有的键值对
  static Future<void> clearAll() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
