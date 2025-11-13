import 'package:flutter/material.dart';

class DrinkTypeForm extends StatefulWidget {
  final String initialName;
  final double initialAlcoholPercentage;
  final void Function(
    String name,
    double alcoholPercentage,
  )
  onSubmit;

  const DrinkTypeForm({
    super.key,
    required this.initialName,
    required this.initialAlcoholPercentage,
    required this.onSubmit,
  });

  @override
  State<DrinkTypeForm> createState() => _DrinkTypeFormState();
}

class _DrinkTypeFormState extends State<DrinkTypeForm> {
  final _formKey = GlobalKey<FormState>();
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
                const SizedBox(height: 16),
                _buildAlcoholPercentageInput(),
              ],
            ),
          ),
        ),
        _buildSubmitButton(context),
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
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number.';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final name = _nameController.text;
            final alcoholPercentage = double.parse(
              _alcoholPercentageController.text,
            );
            final roundedAlcoholPercentage =
                (alcoholPercentage * 100).round() / 100;
            widget.onSubmit(
              name,
              roundedAlcoholPercentage,
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
