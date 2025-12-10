import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/service/user_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

const _maxUsernameLength = 20;
const _minUsernameLength = 3;

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final _userService = get<UserService>();

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _userService.currentUser;
    if (mounted) {
      _usernameController.text = user.username;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Change your username'),
      onFabPressed: _submitForm,
      child: Form(
        key: _formKey,
        child: Column(children: [_buildUsernameInput()]),
      ),
    );
  }

  Widget _buildUsernameInput() {
    return TextFormField(
      controller: _usernameController,
      maxLength: _maxUsernameLength,
      inputFormatters: [LengthLimitingTextInputFormatter(_maxUsernameLength)],
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Username cannot be empty.';
        }
        if (value.trim().length < _minUsernameLength) {
          return 'Username must be at least $_minUsernameLength characters long.';
        }
        return null;
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newUsername = _usernameController.text.trim();
      await _userService.updateUsername(newUsername: newUsername);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
