import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  /// Llama al endpoint /login para autenticación
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return LoginResponse.fromJson(jsonData);
    } else {
      throw Exception('Login inválido: ${response.body}');
    }
  }
}
