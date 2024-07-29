import 'package:shared_preferences/shared_preferences.dart';

class LogData {
  static String? username;
  static String? useremail;
  static String? token;
  static bool? isLoggedIn;

  void getLogData() async {
    final pref = await SharedPreferences.getInstance();
    isLoggedIn = pref.getBool('isLoggedIn');
    useremail = pref.getString('user_id');
    username = pref.getString('username');
    token = pref.getString('token');
  }
}
