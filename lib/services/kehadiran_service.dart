import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api.dart';
import '../core/storage.dart';

class KehadiranService {
  static Future<void> absenMasuk(Float32List data) async {
    final token = await SecureStorage.getToken();

    final res = await http.post(
      Uri.parse('${Api.baseUrl}/absen/masuk'),
      headers: {
        ...Api.authHeader(token!),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': data.toList(),
      }),
    );

    if (res.statusCode != 200) {
      final body = jsonDecode(res.body);
      throw Exception(body['message'] ?? 'Absen gagal');
    }
  }

  static Future<Map<String, dynamic>> getHistory({
    required int bulan,
    required int tahun,
    int page = 1,
  }) async {
    final token = await SecureStorage.getToken();

    final res = await http.get(
      Uri.parse(
        '${Api.baseUrl}/kehadiran?bulan=$bulan&tahun=$tahun&page=$page',
      ),
      headers: Api.authHeader(token!),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil data kehadiran');
    }

    return jsonDecode(res.body);
  }
}
