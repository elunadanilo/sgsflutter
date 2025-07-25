import 'package:flutter/material.dart';
import '../../models/login_model.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../home/home_screen.dart';
import '../qr/qr_scanner_screen.dart'; // ✅ Escaneo y login automático por QR
import 'dart:convert'; // ✅ Necesario para decodificar JSON si se usa

class LoginScreen extends StatefulWidget {
  final ApiService apiService;

  const LoginScreen({super.key, required this.apiService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = LoginRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final response = await widget.apiService.login(request);

      final authService = AuthService();
      await authService.saveToken(response.accessToken);

      print("✅ Login exitoso: ${response.name}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "❌ Usuario o contraseña incorrectos";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// ✅ Abre escáner QR que realiza login directo al leer QR
  Future<void> _scanQrCode() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QRScannerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login SGS Mobile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Usuario"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text("Iniciar sesión"),
                    ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _scanQrCode,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Leer QR"),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
