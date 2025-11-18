import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/widget/custom_drink_types_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_data/widget/default_drink_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => CustomDrinkTypesPage()),
              ),
              child: const Text('Manage custom drink types'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DefaultDrinkPage(),
                ),
              ),
              child: const Text('Default drink settings'),
            ),

            const SizedBox(height: 80),

            Text('Logged in as ${_authService.authenticatedUser.email}'),
            const SizedBox(height: 20),
            _buildVerificationWidget(context),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _authService.signOut();
  }

  Widget _buildVerificationWidget(BuildContext context) {
    if (_authService.isVerified) {
      return const Text('Email verified');
    } else {
      return ElevatedButton(
        onPressed: () {
          _authService.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Verification email sent! Please check your inbox (including spam).',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        },
        child: const Text('Send verification email'),
      );
    }
  }
}
