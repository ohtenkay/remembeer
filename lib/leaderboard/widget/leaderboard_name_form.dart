import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _maxNameLength = 20;

class LeaderboardNameForm extends StatefulWidget {
  final String initialName;
  final String submitButtonText;
  final Future<void> Function(String name) onSubmit;

  const LeaderboardNameForm({
    super.key,
    required this.initialName,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  State<LeaderboardNameForm> createState() => _LeaderboardNameFormState();
}

class _LeaderboardNameFormState extends State<LeaderboardNameForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: Column(children: [_buildNameInput()]),
          ),
        ),
        _buildSubmitButton(),
      ],
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitForm,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0)),
      child: _isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              widget.submitButtonText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final name = _nameController.text.trim();
      await widget.onSubmit(name);
    }
  }
}
