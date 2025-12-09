import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/leaderboard/model/leaderboard_icon.dart';
import 'package:remembeer/leaderboard/widget/leaderboard_icon_picker.dart';

const _maxNameLength = 20;

class LeaderboardForm extends StatefulWidget {
  final String initialName;
  final LeaderboardIcon initialIcon;
  final String submitButtonText;
  final bool isEditing;
  final Future<void> Function(String name, LeaderboardIcon icon) onSubmit;

  const LeaderboardForm({
    super.key,
    required this.initialName,
    required this.initialIcon,
    required this.submitButtonText,
    required this.onSubmit,
    required this.isEditing,
  });

  @override
  State<LeaderboardForm> createState() => _LeaderboardFormState();
}

class _LeaderboardFormState extends State<LeaderboardForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late LeaderboardIcon _selectedIcon = widget.initialIcon;
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
            child: ListView(
              children: [
                _buildNameInput(),
                if (!widget.isEditing) ...[
                  const SizedBox(height: 24),
                  LeaderboardIconPicker(
                    selectedIcon: _selectedIcon,
                    onIconSelected: (icon) =>
                        setState(() => _selectedIcon = icon),
                  ),
                ],
              ],
            ),
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
      decoration: InputDecoration(
        labelText: 'Leaderboard Name',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(_selectedIcon.icon),
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
      await widget.onSubmit(name, _selectedIcon);
    }
  }
}
