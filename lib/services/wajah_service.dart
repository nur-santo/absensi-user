import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api.dart';
import '../core/storage.dart';

class WajahService {
  static Future<bool> hasWajah() async {
    final token = await SecureStorage.getToken();
    final res = await http.get(
      Uri.parse('${Api.baseUrl}/wajah/check'),
      headers: Api.authHeader(token!),
    );
    return jsonDecode(res.body)['has_wajah'] == true;
  }

  static Future<void> store(Float32List data) async {
  final token = await SecureStorage.getToken();

  final res = await http.post(
    Uri.parse('${Api.baseUrl}/wajah'),
    headers: {
      ...Api.authHeader(token!),       
      'Content-Type': 'application/json', 
    },
    body: jsonEncode({
      'data': data.toList(),
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to store wajah: ${res.statusCode}, ${res.body}');
  }
}

}
