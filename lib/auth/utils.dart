import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  Future<bool> logOut(BuildContext context, {bool silent = true}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('userName');

    if (success && context.mounted) {
      if (!silent) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/Home',
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/Home',
        );
      }
    } else {
      if (!silent && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to log you out"),
          ),
        );
      }
    }
    return success;
  }
}
