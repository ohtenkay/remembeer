import 'package:flutter/material.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';

const _SPACING = SizedBox(height: 16);

class DrinkTypeForm extends StatefulWidget {
  final String initialName;
  final double initialAlcoholPercentage;
  final DrinkCategory initialDrinkCategory;
  final Future<void> Function(
    String name,
    double alcoholPercentage,
    DrinkCategory category,
  )
  onSubmit;
  final Future<void> Function()? onDelete;

  const DrinkTypeForm({
    super.key,
    required this.initialName,
    required this.initialAlcoholPercentage,
    required this.initialDrinkCategory,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<DrinkTypeForm> createState() => _DrinkTypeFormState();
}

class _DrinkTypeFormState extends State<DrinkTypeForm> {
  final _formKey = GlobalKey<FormState>();

  late DrinkCategory? _selectedDrinkCategory = widget.initialDrinkCategory;
  final _nameController = TextEditingController();
  final _alcoholPercentageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _alcoholPercentageController.text = widget.initialAlcoholPercentage
        .toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _alcoholPercentageController.dispose();
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
                _SPACING,
                _buildAlcoholPercentageInput(),
                _SPACING,
                _buildDrinkCategoryDropdown(),
              ],
            ),
          ),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name.';
        }

        return null;
      },
    );
  }

  Widget _buildAlcoholPercentageInput() {
    return TextFormField(
      controller: _alcoholPercentageController,
      decoration: const InputDecoration(
        labelText: 'Alcohol Percentage (%)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an alcohol percentage.';
        }
        final percentage = double.tryParse(value);
        if (percentage == null || percentage < 0 || percentage > 100) {
          return 'Please enter a valid number.';
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
            await _submitForm(context);
          },
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(30.0)),
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

  Widget _buildDrinkCategoryDropdown() {
    return DropdownButtonFormField<DrinkCategory>(
      initialValue: _selectedDrinkCategory,
      hint: const Text('Select Category'),
      items: DrinkCategory.values.map((drinkCategory) {
        return DropdownMenuItem(
          value: drinkCategory,
          child: Text(drinkCategory.displayName),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedDrinkCategory = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a category.';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final alcoholPercentage = double.parse(_alcoholPercentageController.text);
      final roundedAlcoholPercentage = (alcoholPercentage * 100).round() / 100;
      await widget.onSubmit(
        name,
        roundedAlcoholPercentage,
        _selectedDrinkCategory!,
      );
    }
  }
}
