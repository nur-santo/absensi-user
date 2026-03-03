import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static final String ip = dotenv.env['API_IP'] ?? '127.0.0.1';

  static final String port = dotenv.env['API_PORT'] ?? '8000';

  static final String baseUrl = 'http://$ip:$port/api';

  static Map<String, String> authHeader(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }
}
