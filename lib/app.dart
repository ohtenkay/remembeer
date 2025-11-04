import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/controller/auth_controller.dart';
import 'package:remembeer/auth/widget/login_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/page_switcher.dart';

class App extends StatelessWidget {
  App({super.key});

  final _authController = get<AuthController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remembeer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: _buildAuthGate(),
    );
  }

  StreamBuilder<User?> _buildAuthGate() {
    return StreamBuilder<User?>(
      stream: _authController.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const PageSwitcher();
        }

        return const LoginPage();
      },
    );
  }
}
