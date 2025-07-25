import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import '../../models/login_model.dart';
import '/core/utils/crypto_utils.dart'; // 👈 Importamos descifrado
import 'dart:convert';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  void _handleQRCode(BuildContext context, BarcodeCapture capture) async {
  try {
    final barcode = capture.barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue == null || rawValue.isEmpty) {
      print('⚠️ Código QR vacío');
      return;
    }

    final decryptedJson = CryptoUtils.decryptAES(rawValue);
    print("🔓 JSON descifrado: $decryptedJson");

    final Map<String, dynamic> credentials = json.decode(decryptedJson);

    final String? username = credentials['username'] ?? credentials['user'];
    final String? password = credentials['password'];
    final String? token = credentials['token'];
    final String? serverApi = credentials['serverApi'];

    if (username == null || token == null || serverApi == null) {
      throw const FormatException('❌ QR no contiene credenciales suficientes');
    }

    final authService = AuthService();
    await authService.saveToken(token);

    final apiService = ApiService(baseUrl: serverApi);

    // Si password es necesario, podrías validar también
    // final loginRequest = LoginRequest(username: username, password: password!);
    // final loginResponse = await apiService.login(loginRequest);
    // await authService.saveToken(loginResponse.accessToken);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  } catch (e) {
    print('❌ Error escaneando QR o iniciando sesión: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(
        controller: MobileScannerController(formats: [BarcodeFormat.qrCode]),
        onDetect: (capture) => _handleQRCode(context, capture),
      ),
    );
  }
}
