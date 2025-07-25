import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/login_model.dart';

class ApiService {
  final String baseUrl;

  /// Constructor del servicio que recibe la URL base del API.
  ApiService({required this.baseUrl});

  /// Método para realizar el login.
  /// 
  /// Envia una solicitud POST con usuario y contraseña,
  /// y retorna un [LoginResponse] con el token si es exitoso.
  /// 
  /// Lanza una excepción si la solicitud falla o si la respuesta es inválida.
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/login'); // Ejemplo: https://api.sgs.dominion.es/api/login

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LoginResponse.fromJson(json);
    } else {
      // Puedes lanzar una excepción personalizada o simplemente devolver un error
      throw Exception('❌ Error al hacer login: ${response.statusCode} - ${response.body}');
    }
  }
}
