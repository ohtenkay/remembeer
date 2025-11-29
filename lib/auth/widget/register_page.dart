import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = get<AuthService>();
  final UserService _userService = get<UserService>();
  final UserSettingsService _userSettingsService = get<UserSettingsService>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Register'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _register,
            child: const Text('Register'),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _userSettingsService.createDefaultUserSettings();
      await _userService.createDefaultUser();

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        // TODO(metju-ac): Proper error handling
        _errorMessage = e.message ?? 'Registration failed';
      });
    }
  }
}
