import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remembeer/auth/page/register_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = get<AuthService>();
  final _userService = get<UserService>();
  final _userSettingsService = get<UserSettingsService>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoading = false;
  var _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PageTemplate(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 48),
          _buildForm(context),
          const SizedBox(height: 24),
          _buildDivider(theme),
          const SizedBox(height: 24),
          _buildGoogleSignIn(),
          const SizedBox(height: 16),
          _buildRegisterLink(context),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        DrinkIcon(
          category: DrinkCategory.beer,
          size: 100,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Remembeer',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your drinks, compete with friends',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            ErrorMessageBox(message: _errorMessage!),
          ],
          const SizedBox(height: 8),
          _buildForgotPassword(context),
          const SizedBox(height: 16),
          _buildLoginButton(theme),
        ],
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
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      enabled: !_isLoading,
      onFieldSubmitted: (_) => _login(),
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password.';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () => _showPasswordResetDialog(context),
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return FilledButton(
      onPressed: _isLoading ? null : _login,
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
          : const Text('Login', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _signInWithGoogle,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        minimumSize: const Size(300, 0),
      ),
      icon: SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20),
      label: const Text('Sign in with Google', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return TextButton(
      onPressed: _isLoading
          ? null
          : () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const RegisterPage(),
              ),
            ),
      child: const Text("Don't have an account? Register"),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = mapFirebaseAuthError(e.code));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.signInWithGoogle();

      if (result != null && result.isNewUser) {
        await _userSettingsService.createDefaultUserSettings();
        await _userService.createDefaultUser();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = mapFirebaseAuthError(e.code));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showPasswordResetDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your email address and we'll send you a link to reset your password.",
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isEmpty) return;

                _authService.resetPassword(email: email);
                Navigator.of(context).pop();
                showNotification(
                  context,
                  'Password reset email sent! Check your inbox (including spam).',
                );
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
