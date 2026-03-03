import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api.dart';
import '../core/storage.dart';
import '../models/user_model.dart';

class AuthService {

  // ================= LOGIN =================
  static Future<String?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('${Api.baseUrl}/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      final Map<String, dynamic> json =
          res.body.isNotEmpty ? jsonDecode(res.body) : {};

      if (res.statusCode != 200) {
        return json['message'] ?? "Login gagal";
      }

      final token = json['token'];
      if (token == null || token.toString().isEmpty) {
        return "Token tidak ditemukan";
      }

      await SecureStorage.saveToken(token);
      return null; // null = sukses
    } catch (e) {
      print('login error: $e');
      return "Terjadi kesalahan koneksi";
    }
  }

  // ================= RESET PASSWORD =================
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final res = await http.post(
        Uri.parse('${Api.baseUrl}/reset-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
        }),
      );

      final Map<String, dynamic> json =
          res.body.isNotEmpty ? jsonDecode(res.body) : {};

      if (res.statusCode != 200) {
        return {
          "success": false,
          "message": json['message'] ?? "Gagal reset password",
        };
      }

      return {
        "success": true,
        "message": json['message'] ?? "Password berhasil direset",
        "new_password": json['new_password'], // kalau backend kirim
      };

    } catch (e) {
      print('resetPassword error: $e');
      return {
        "success": false,
        "message": "Terjadi kesalahan koneksi",
      };
    }
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    await SecureStorage.logout();
  }

  // ================= GET USER =================
  static Future<UserModel?> getMe() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null || token.isEmpty) return null;

      final res = await http.get(
        Uri.parse('${Api.baseUrl}/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode != 200) return null;

      final Map<String, dynamic> json =
          res.body.isNotEmpty ? jsonDecode(res.body) : {};

      return UserModel.fromJson(json);

    } catch (e) {
      print('getMe error: $e');
      return null;
    }
  }
}