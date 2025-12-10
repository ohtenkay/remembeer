import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class EndOfDayPage extends StatefulWidget {
  const EndOfDayPage({super.key});

  @override
  State<EndOfDayPage> createState() => _EndOfDayPageState();
}

class _EndOfDayPageState extends State<EndOfDayPage> {
  final _userSettingsService = get<UserSettingsService>();

  TimeOfDay? _selectedEndOfDayBoundary;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('End of Day'),
      onFabPressed: _saveSettings,
      child: AsyncBuilder(
        future: _userSettingsService.currentUserSettings,
        builder: (context, userSettings) {
          _selectedEndOfDayBoundary ??= userSettings.endOfDayBoundary;

          return Column(
            children: [
              ListTile(
                title: Text(_selectedEndOfDayBoundary!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndOfDayBoundary!,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedEndOfDayBoundary = pickedTime;
      });
    }
  }

  Future<void> _saveSettings() async {
    await _userSettingsService.updateEndOfDayBoundary(
      _selectedEndOfDayBoundary!,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
