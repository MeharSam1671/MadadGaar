import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:madadgaar/firebase_options.dart';
import 'package:madadgaar/login/signup/signup.dart';
import 'package:madadgaar/settings/settings.dart';
import 'package:madadgaar/splashscreen.dart';
import 'package:madadgaar/utils/api_controller.dart';
import 'package:madadgaar/utils/socket_client.dart';
import 'Home/home.dart';
import 'Maps/maps.dart';
import 'Profile/profile.dart';
import 'login/signup/login.dart';
import 'package:madadgaar/Home/newhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    ApiController(
      baseUrl: 'http://10.0.2.2:4000/api', // Replace with your API base URL
    );
    SocketClient(
      baseUrl: 'http://10.0.2.2:4000/api', // Replace with your API base URL
    );
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  });
}

// ThemeProvider class for managing theme state
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// Dark Theme
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.blueGrey,
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
  colorScheme: const ColorScheme.dark(),
);

// Light Theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  colorScheme: const ColorScheme.light(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String home = "home";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      routes: {
        "/maps": (context) => const Maps(),
        "/Home": (context) => const Home(),
        "/Signup": (context) => const SignupScreen(),
        '/showProfile': (context) => const ProfileScreen(),
        '/LoginProfile': (context) => const LoginScreen(),
        '/Settings': (context) => const SettingsPage(),
        '/Newhome': (context) => const Newhome(),
      },

      //home:  SplashScreen(home: home),
      home: const SplashScreen(home: home),
      // home: LoginScreen(),
    );
  }
}
