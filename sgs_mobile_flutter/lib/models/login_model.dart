// Modelo que representa la petición y respuesta del login

/// Representa los datos enviados al iniciar sesión.
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

/// Representa los datos devueltos por el servidor tras iniciar sesión exitosamente.
class LoginResponse {
  final String accessToken;
  final String expires;
  final int idEmployee;
  final String name;

  LoginResponse({
    required this.accessToken,
    required this.expires,
    required this.idEmployee,
    required this.name,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      expires: json['expires'],
      idEmployee: json['id_employee'],
      name: json['name'],
    );
  }
}
