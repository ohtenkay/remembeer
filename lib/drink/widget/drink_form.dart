import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type.dart';
import 'package:remembeer/drink_type/widget/drink_type_picker.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/location/page/location_page.dart';
import 'package:remembeer/location/service/location_service.dart';

const _spacing = SizedBox(height: 16);

class DrinkForm extends StatefulWidget {
  final DrinkType initialDrinkType;
  final DateTime initialConsumedAt;
  final int initialVolume;
  final GeoPoint? initialLocation;
  final Future<void> Function(
    DrinkType drinkType,
    DateTime consumedAt,
    int volumeInMilliliters,
    GeoPoint? location,
  )
  onSubmit;

  const DrinkForm({
    super.key,
    required this.initialDrinkType,
    required this.initialConsumedAt,
    required this.initialVolume,
    this.initialLocation,
    required this.onSubmit,
  });

  @override
  State<DrinkForm> createState() => _DrinkFormState();
}

class _DrinkFormState extends State<DrinkForm> {
  final _formKey = GlobalKey<FormState>();
  final _locationService = get<LocationService>();

  late DrinkType _selectedDrinkType = widget.initialDrinkType;
  late DateTime _selectedConsumedAt = widget.initialConsumedAt;
  final _volumeController = TextEditingController();
  final _consumedAtController = TextEditingController();
  final _locationController = TextEditingController();

  GeoPoint? _location;
  var _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _consumedAtController.text = _formatDateTime(_selectedConsumedAt);
    _volumeController.text = widget.initialVolume.toString();
    _location = widget.initialLocation;
    _updateLocationText();
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _consumedAtController.dispose();
    _locationController.dispose();
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
                _spacing,
                _buildLocationInput(),
              ],
            ),
          ),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _locationController,
          readOnly: true,
          onTap: _location != null ? _viewLocationOnMap : null,
          decoration: InputDecoration(
            labelText: 'Location (optional)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.location_on),
            suffixIcon: _location != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _location = null;
                            _updateLocationText();
                          });
                        },
                      ),
                    ],
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isLoadingLocation ? null : _fetchCurrentLocation,
          icon: _isLoadingLocation
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
          label: Text(
            _isLoadingLocation ? 'Getting location...' : 'Use current location',
          ),
        ),
      ],
    );
  }

  void _viewLocationOnMap() {
    if (_location == null) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LocationPage(location: _location!),
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
      buttons
        ..add(_buildVolumeButton(name: name, volume: volume))
        ..add(const SizedBox(width: 8));
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
      await widget.onSubmit(
        _selectedDrinkType,
        _selectedConsumedAt,
        volume,
        _location,
      );
    }
  }

  void _updateLocationText() {
    if (_location != null) {
      _locationController.text =
          '${_location!.latitude.toStringAsFixed(5)}, ${_location!.longitude.toStringAsFixed(5)}';
    } else {
      _locationController.text = '';
    }
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    final position = await _locationService.getCurrentPosition();
    if (mounted) {
      setState(() {
        _isLoadingLocation = false;
        if (position != null) {
          _location = GeoPoint(position.latitude, position.longitude);
          _updateLocationText();
        }
      });
    }
  }
}
