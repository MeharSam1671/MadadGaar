import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  Future<bool> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('userName');
    return success;
  }
}
