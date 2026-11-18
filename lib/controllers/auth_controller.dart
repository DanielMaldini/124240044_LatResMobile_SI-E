import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxnString username = RxnString();

  // Dipanggil saat aplikasi dibuka: apakah masih ada sesi login?
  Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('sessionUser');
    return username.value != null;
  }

  // Mengembalikan pesan error, atau null jika berhasil
  Future<String?> register(String user, String pass) async {
    if (user.isEmpty || pass.isEmpty) {
      return 'Username dan password wajib diisi';
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_$user')) {
      return 'Username sudah terdaftar';
    }
    await prefs.setString('user_$user', pass);
    return null;
  }

  Future<bool> login(String user, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('user_$user');
    if (saved == null || saved != pass) return false;
    await prefs.setString('sessionUser', user);
    username.value = user;
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionUser');
    username.value = null;
  }
}