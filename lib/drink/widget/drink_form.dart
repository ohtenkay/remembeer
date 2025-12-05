import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/widget/drink_type_picker.dart';

const _spacing = SizedBox(height: 16);

// TODO(metju-ac): add location
class DrinkForm extends StatefulWidget {
  final DrinkType initialDrinkType;
  final DateTime initialConsumedAt;
  final int initialVolume;
  final Future<void> Function(
    DrinkType drinkType,
    DateTime consumedAt,
    int volumeInMilliliters,
  )
  onSubmit;

  const DrinkForm({
    super.key,
    required this.initialDrinkType,
    required this.initialConsumedAt,
    required this.initialVolume,
    required this.onSubmit,
  });

  @override
  State<DrinkForm> createState() => _DrinkFormState();
}

class _DrinkFormState extends State<DrinkForm> {
  final _formKey = GlobalKey<FormState>();

  late DrinkType _selectedDrinkType = widget.initialDrinkType;
  late DateTime _selectedConsumedAt = widget.initialConsumedAt;
  final _volumeController = TextEditingController();
  final _consumedAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _consumedAtController.text = _formatDateTime(_selectedConsumedAt);
    _volumeController.text = widget.initialVolume.toString();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _consumedAtController.dispose();
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
                _buildDrinkTypeDropdown(),
                _spacing,
                _buildVolumeInput(),
                const SizedBox(height: 8),
                _buildPredefinedVolumesRow(),
                _spacing,
                _buildConsumedAtInput(),
              ],
            ),
          ),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM. yyyy, H:mm').format(dateTime);
  }

  Future<void> _selectConsumedAt() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedConsumedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedConsumedAt),
    );
    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedConsumedAt = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
    _consumedAtController.text = _formatDateTime(_selectedConsumedAt);
  }

  Widget _buildDrinkTypeDropdown() {
    return DrinkTypePicker(
      selectedDrinkType: _selectedDrinkType,
      onChanged: (newValue) {
        setState(() {
          _selectedDrinkType = newValue;
        });
      },
    );
  }

  Widget _buildVolumeInput() {
    return TextFormField(
      controller: _volumeController,
      decoration: const InputDecoration(
        labelText: 'Volume (ml)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a volume.';
        }
        final volume = int.tryParse(value);
        if (volume == null || volume <= 0) {
          return 'Please enter a valid number.';
        }
        return null;
      },
    );
  }

  Widget _buildVolumeButton({required String name, required int volume}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _volumeController.text = volume.toString(),
        child: Text(name),
      ),
    );
  }

  Widget _buildPredefinedVolumesRow() {
    final volumes = _selectedDrinkType.category.predefinedVolumes;
    final buttons = <Widget>[];
    // TODO(metju-ac): improve this logic when doing UI, consider Wrap component
    volumes.forEach((name, volume) {
      buttons.add(_buildVolumeButton(name: name, volume: volume));
      buttons.add(const SizedBox(width: 8));
    });

    if (buttons.isNotEmpty) {
      buttons.removeLast();
    }

    return Row(children: buttons);
  }

  Widget _buildConsumedAtInput() {
    return TextFormField(
      controller: _consumedAtController,
      readOnly: true,
      onTap: _selectConsumedAt,
      decoration: const InputDecoration(
        labelText: 'Consumed at',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select when you consumed the drink.';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            await _submitForm();
          },
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(30.0)),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final volume = int.parse(_volumeController.text);
      await widget.onSubmit(_selectedDrinkType, _selectedConsumedAt, volume);
    }
  }
}
