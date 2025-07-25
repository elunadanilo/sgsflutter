import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    return isLoggedIn ? const HomeScreen() : LoginScreen(apiService: ApiService(baseUrl: 'https://sgs.dominion.es/Web/api/'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGS Mobile',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
