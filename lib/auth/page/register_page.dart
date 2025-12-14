import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/auth/constants.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/auth/widget/password_text_field.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/constants.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

const _gap8 = SizedBox(height: 8);
const _gap16 = SizedBox(height: 16);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = get<AuthService>();
  final _userService = get<UserService>();
  final _userSettingsService = get<UserSettingsService>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _isLoading = false;
  var _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Create Account'),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailField(),
            _gap16,
            _buildUsernameField(),
            _gap16,
            PasswordTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: _obscurePassword,
              onToggleVisibility: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              enabled: !_isLoading,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password.';
                }
                if (!isPasswordValid(value)) {
                  return 'Password does not meet requirements.';
                }
                return null;
              },
            ),
            _gap8,
            PasswordRequirements(password: _passwordController.text),
            _gap16,
            PasswordTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscureText: _obscurePassword,
              onToggleVisibility: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: () => _register(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password.';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              _gap16,
              ErrorMessageBox(message: _errorMessage!),
            ],
            const SizedBox(height: 24),
            _buildRegisterButton(context),
            _gap16,
            _buildLoginLink(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: !_isLoading,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email.';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      textInputAction: TextInputAction.next,
      enabled: !_isLoading,
      maxLength: maxUsernameLength,
      inputFormatters: [LengthLimitingTextInputFormatter(maxUsernameLength)],
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person_outline),
        helperText: 'This is how other users will see you.',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a username.';
        }
        if (value.trim().length < minUsernameLength) {
          return 'Username must be at least $minUsernameLength characters.';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton(
      onPressed: _isLoading ? null : () => _register(context),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : const Text('Create Account', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return TextButton(
      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
      child: const Text('Already have an account? Login'),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _userSettingsService.createDefaultUserSettings();
      await _userService.createDefaultUser(
        username: _usernameController.text.trim(),
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = mapFirebaseAuthError(e.code));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
