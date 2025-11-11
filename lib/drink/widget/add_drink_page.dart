import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink/model/drink_create.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/ioc/ioc_container.dart';

final List<DrinkType> hardcodedDrinkTypes = [
  DrinkType(
    id: 'pilsner',
    name: 'Pilsner Urquell',
    category: DrinkCategory.Beer,
    alcoholPercentage: 4.4,
  ),
  DrinkType(
    id: 'radegast',
    name: 'Radegast',
    category: DrinkCategory.Beer,
    alcoholPercentage: 5.1,
  ),
  DrinkType(
    id: 'starobrno',
    name: 'Starobrno',
    category: DrinkCategory.Beer,
    alcoholPercentage: 4.0,
  ),
];

const _SPACING = SizedBox(height: 16);

// TODO(metju-ac): add location
class AddDrinkPage extends StatefulWidget {
  AddDrinkPage({super.key});

  final _drinkController = get<DrinkController>();

  @override
  State<AddDrinkPage> createState() => _AddDrinkPageState();
}

class _AddDrinkPageState extends State<AddDrinkPage> {
  final _formKey = GlobalKey<FormState>();

  DrinkType? _selectedDrinkType = hardcodedDrinkTypes.first;
  DateTime _selectedConsumedAt = DateTime.now();
  final _volumeController = TextEditingController();
  final _consumedAtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _consumedAtController.text = _formatDateTime(_selectedConsumedAt);
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _consumedAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Record a Drink'),
      child: Column(
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
          _buildSubmitButton(context),
        ],
      ),
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

  DropdownButtonFormField<DrinkType> _buildDrinkTypeDropdown() {
    return DropdownButtonFormField<DrinkType>(
      initialValue: _selectedDrinkType,
      hint: const Text('Select a drink'),
      items: hardcodedDrinkTypes.map((drinkType) {
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
  }

  TextFormField _buildVolumeInput() {
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

  Expanded _buildVolumeButton({required String name, required double volume}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _volumeController.text = volume.toString(),
        child: Text(name),
      ),
    );
  }

  Row _buildPredefinedVolumesRow() {
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

  TextFormField _buildConsumedAtInput() {
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

  SizedBox _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final volume = int.parse(_volumeController.text);
            widget._drinkController.createSingle(
              DrinkCreate(
                consumedAt: _selectedConsumedAt,
                drinkType: _selectedDrinkType!,
                volumeInMilliliters: volume,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(30.0),
        ),
        child: const Text('Submit'),
      ),
    );
  }
}
