import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';

const _maxNameLength = 20;

class CreateLeaderboardPage extends StatefulWidget {
  const CreateLeaderboardPage({super.key});

  @override
  State<CreateLeaderboardPage> createState() => _CreateLeaderboardPageState();
}

class _CreateLeaderboardPageState extends State<CreateLeaderboardPage> {
  final _leaderboardService = get<LeaderboardService>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Create Leaderboard'),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(children: [_buildNameInput()]),
            ),
          ),
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      maxLength: _maxNameLength,
      inputFormatters: [LengthLimitingTextInputFormatter(_maxNameLength)],
      decoration: const InputDecoration(
        labelText: 'Leaderboard Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.emoji_events),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name cannot be empty.';
        }
        if (value.trim().length < 3) {
          return 'Name must be at least 3 characters long.';
        }
        return null;
      },
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
      child: const Text(
        'Create Leaderboard',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      await _leaderboardService.createLeaderboard(name);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
