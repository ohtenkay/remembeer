import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/widget/drink_type_dropdown.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_data/service/user_data_service.dart';

class DefaultDrinkPage extends StatefulWidget {
  const DefaultDrinkPage({
    super.key,
  });

  @override
  State<DefaultDrinkPage> createState() => _DefaultDrinkPageState();
}

class _DefaultDrinkPageState extends State<DefaultDrinkPage> {
  final _userDataService = get<UserDataService>();
  final _formKey = GlobalKey<FormState>();

  DrinkType? _selectedDrinkType;
  int? _selectedVolume;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Default drink'),
      child: AsyncBuilder(
        future: _userDataService.getCurrentUserData,
        builder: (context, userData) {
          _selectedDrinkType ??= userData.defaultDrinkType;
          _selectedVolume ??= userData.defaultDrinkSize;

          return Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildDrinkTypeDropdown(),
                      const SizedBox(height: 16),
                      _buildVolumeInput(),
                    ],
                  ),
                ),
              ),
              _buildSaveButton(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _userDataService.updateDefaultDrinkType(_selectedDrinkType!);
    await _userDataService.updateDefaultDrinkSize(_selectedVolume!);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildSaveButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            await _saveSettings();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(30.0),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildVolumeInput() {
    return TextFormField(
      initialValue: _selectedVolume?.toString(),
      decoration: const InputDecoration(
        labelText: 'Default Volume (ml)',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a volume';
        }
        final volume = int.tryParse(value);
        if (volume == null || volume <= 0) {
          return 'Please enter a valid volume';
        }
        return null;
      },
      onChanged: (value) {
        _selectedVolume = int.tryParse(value);
      },
    );
  }

  Widget _buildDrinkTypeDropdown() {
    return DrinkTypeDropdown(
      selectedDrinkType: _selectedDrinkType,
      onChanged: (newValue) {
        setState(() {
          _selectedDrinkType = newValue;
        });
      },
    );
  }
}
