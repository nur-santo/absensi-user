import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api.dart';
import '../core/storage.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${Api.baseUrl}/login'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    if (res.statusCode != 200) return false;

    final json = jsonDecode(res.body);

    // asumsi response:
    // { "token": "xxxx" }
    await SecureStorage.saveToken(json['token']);
    return true;
  }

  static Future<void> logout() async {
    await SecureStorage.logout();
  }


  static Future<UserModel?> getMe() async {
    try {
      final token = await SecureStorage.getToken();

      if (token == null || token.isEmpty) {
        return null;
      }

      final res = await http.get(
        Uri.parse('${Api.baseUrl}/me'),
        headers: Api.authHeader(token),
      );

      if (res.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(res.body);
      return UserModel.fromJson(json);
    } catch (e) {
      print('getMe error: $e');
      return null;
    }
  }

  static Future<bool> requestOtp(String email) async {
  try {
    final res = await http.post(
      Uri.parse('${Api.baseUrl}/request-otp'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    return res.statusCode == 200;
  } catch (e) {
    print('requestOtp error: $e');
    return false;
  }
}

  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      final res = await http.post(
        Uri.parse('${Api.baseUrl}/verify-otp'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'otp': otp,
        },
      );

      if (res.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print('verifyOtp error: $e');
      return false;
    }
  }

  static Future<bool> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Api.baseUrl}/reset-password'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (res.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print('resetPassword error: $e');
      return false;
    }
  }
}
