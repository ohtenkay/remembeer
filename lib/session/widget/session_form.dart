import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const _maxNameLength = 30;

class SessionForm extends StatefulWidget {
  final String initialName;
  final DateTime initialStartedAt;
  final String submitButtonText;
  final Future<void> Function(String name, DateTime startedAt) onSubmit;

  const SessionForm({
    super.key,
    required this.initialName,
    required this.initialStartedAt,
    required this.submitButtonText,
    required this.onSubmit,
  });

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startedAtController = TextEditingController();

  late DateTime _selectedStartedAt = widget.initialStartedAt;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _startedAtController.text = _formatDateTime(_selectedStartedAt);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startedAtController.dispose();
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
                const SizedBox(height: 24),
                _buildStartedAtInput(),
              ],
            ),
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM. yyyy, H:mm').format(dateTime);
  }

  Future<void> _selectStartedAt() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedDate == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedStartedAt),
    );
    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedStartedAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
    _startedAtController.text = _formatDateTime(_selectedStartedAt);
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      maxLength: _maxNameLength,
      inputFormatters: [LengthLimitingTextInputFormatter(_maxNameLength)],
      decoration: const InputDecoration(
        labelText: 'Session Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.celebration),
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

  Widget _buildStartedAtInput() {
    return TextFormField(
      controller: _startedAtController,
      readOnly: true,
      onTap: _selectStartedAt,
      decoration: const InputDecoration(
        labelText: 'Start Time',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select when the session starts.';
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
      await widget.onSubmit(name, _selectedStartedAt);
    }
  }
}
