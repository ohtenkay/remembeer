import 'package:flutter/material.dart';
import 'package:remembeer/auth/controller/auth_controller.dart';
import 'package:remembeer/ioc/ioc_container.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final _authController = get<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Logged in as ${_authController.authenticatedUser.email}'),
          const SizedBox(height: 20),
          _buildVerificationWidget(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await _authController.signOut();
  }

  Widget _buildVerificationWidget() {
    if (_authController.isVerified) {
      return const Text('Email verified');
    } else {
      return ElevatedButton(
        onPressed: () => _authController.sendEmailVerification(),
        child: const Text('Send verification email'),
      );
    }
  }
}
