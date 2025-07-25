class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

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
