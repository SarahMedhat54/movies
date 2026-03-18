import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_data.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveUser(UserData user) async {
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
    UserData.currentUser = user;
  }

  static UserData? getUser() {
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      UserData.currentUser = UserData.fromJson(jsonDecode(userJson));
      return UserData.currentUser;
    }
    return null;
  }

  static bool isLoggedIn() {
    return getUser() != null;
  }

  static Future<void> clearCache() async {
    await prefs.remove('user');
    await prefs.remove('isLoggedIn'); // fallback from earlier logic
    UserData.currentUser = null;
  }

  static Future<void> skipOnboarding() async {
    await prefs.setBool('skippedOnboarding', true);
  }

  static bool isSkippedOnboarding() {
    return prefs.getBool('skippedOnboarding') ?? false;
  }
}
