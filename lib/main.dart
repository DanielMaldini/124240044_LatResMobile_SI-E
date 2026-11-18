import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'controllers/favorite_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = Get.put(AuthController(), permanent: true);
  Get.put(FavoriteController(), permanent: true); // tambahkan ini
  final loggedIn = await auth.restoreSession();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Space News',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: loggedIn ? const HomePage() : const LoginPage(),
    );
  }
}