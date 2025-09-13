import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> setIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstLaunch", true);
  }

  static Future<void> removeIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isFirstLaunch");
  }

  static Future<bool> getIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool("isFirstLaunch") ?? false;

    return isFirstLaunch;
  }
}
