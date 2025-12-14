import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/constants.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/auth/util/firebase_error_mapper.dart';
import 'package:remembeer/auth/widget/password_requirements.dart';
import 'package:remembeer/auth/widget/password_text_field.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';

const _gap16 = SizedBox(height: 16);

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _authService = get<AuthService>();

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _isLoading = false;
  var _obscureCurrentPassword = true;
  var _obscureNewPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Change Password'),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentPasswordTextField(),
            _gap16,
            _buildNewPasswordTextField(),
            const SizedBox(height: 8),
            PasswordRequirements(password: _newPasswordController.text),
            _gap16,
            _buildRepeatNewPasswordTextInput(context),
            if (_errorMessage != null) ...[
              _gap16,
              ErrorMessageBox(message: _errorMessage!),
            ],
            const SizedBox(height: 24),
            _buildChangePasswordButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatNewPasswordTextInput(BuildContext context) {
    return PasswordTextField(
      controller: _confirmPasswordController,
      label: 'Confirm New Password',
      obscureText: _obscureNewPassword,
      onToggleVisibility: () =>
          setState(() => _obscureNewPassword = !_obscureNewPassword),
      enabled: !_isLoading,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: () => _changePassword(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your new password.';
        }
        if (value != _newPasswordController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordTextField() {
    return PasswordTextField(
      controller: _newPasswordController,
      label: 'New Password',
      obscureText: _obscureNewPassword,
      onToggleVisibility: () =>
          setState(() => _obscureNewPassword = !_obscureNewPassword),
      enabled: !_isLoading,
      onChanged: (_) => setState(() {}),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a new password.';
        }
        if (!isPasswordValid(value)) {
          return 'Password does not meet requirements.';
        }
        if (value == _currentPasswordController.text) {
          return 'New password must be different from current.';
        }
        return null;
      },
    );
  }

  Widget _buildCurrentPasswordTextField() {
    return PasswordTextField(
      controller: _currentPasswordController,
      label: 'Current Password',
      obscureText: _obscureCurrentPassword,
      onToggleVisibility: () =>
          setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
      enabled: !_isLoading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your current password.';
        }
        return null;
      },
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton(
      onPressed: _isLoading ? null : () => _changePassword(context),
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
          : const Text('Change Password', style: TextStyle(fontSize: 16)),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.updatePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (context.mounted) {
        showNotification(context, 'Password changed successfully.');
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
