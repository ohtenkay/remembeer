import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/loading_stream_builder.dart';
import 'package:remembeer/drink_type/controller/drink_type_controller.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/ioc/ioc_container.dart';

const _SPACING = SizedBox(height: 16);

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
  final Future<void> Function()? onDelete;

  const DrinkForm({
    super.key,
    required this.initialDrinkType,
    required this.initialConsumedAt,
    required this.initialVolume,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<DrinkForm> createState() => _DrinkFormState();
}

class _DrinkFormState extends State<DrinkForm> {
  final DrinkTypeController _drinkTypeController = get<DrinkTypeController>();
  final _formKey = GlobalKey<FormState>();

  late DrinkType? _selectedDrinkType = widget.initialDrinkType;
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
                _SPACING,
                _buildVolumeInput(),
                const SizedBox(height: 8),
                _buildPredefinedVolumesRow(),
                _SPACING,
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
    return LoadingStreamBuilder(
      stream: _drinkTypeController.allAvailableDrinkTypesStream,
      builder: (context, unmodifiableDrinkTypes) {
        final drinkTypes = unmodifiableDrinkTypes.toList();
        if (_selectedDrinkType != null &&
            !drinkTypes.contains(_selectedDrinkType)) {
          drinkTypes.insert(0, _selectedDrinkType!);
        }

        return DropdownButtonFormField<DrinkType>(
          initialValue: _selectedDrinkType,
          hint: const Text('Select a drink'),
          items: drinkTypes.map((drinkType) {
            return DropdownMenuItem(
              value: drinkType,
              child: Text(drinkType.name),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedDrinkType = newValue;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your drink.';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Drink',
            border: OutlineInputBorder(),
          ),
        );
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
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number.';
        }
        return null;
      },
    );
  }

  Widget _buildVolumeButton({required String name, required double volume}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _volumeController.text = volume.toString(),
        child: Text(name),
      ),
    );
  }

  Widget _buildPredefinedVolumesRow() {
    return Row(
      children: [
        _buildVolumeButton(name: 'Tuplacek', volume: 1000),
        const SizedBox(width: 8),
        _buildVolumeButton(name: 'Big', volume: 500),
        const SizedBox(width: 8),
        _buildVolumeButton(name: 'Small', volume: 300),
      ],
    );
  }

  Widget _buildConsumedAtInput() {
    return TextFormField(
      controller: _consumedAtController,
      readOnly: true,
      onTap: _selectConsumedAt,
      decoration: InputDecoration(
        labelText: 'Consumed at',
        border: OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
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
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(30.0),
          ),
          child: const Text('Submit'),
        ),
        if (widget.onDelete != null) ...[
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (widget.onDelete != null) {
                await widget.onDelete!();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(30.0),
            ),
            child: const Text('Delete'),
          ),
        ],
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final volume = int.parse(_volumeController.text);
      await widget.onSubmit(
        _selectedDrinkType!,
        _selectedConsumedAt,
        volume,
      );
    }
  }
}
