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
      hint:
          'This time defines when a day ends. For example, if set to 6:00 AM '
          'and viewing the 10th, drinks from 10th 6:00 AM to 11th 6:00 AM '
          'will be shown. This has no effect on statictics or streak '
          'calculations (they always use midnight as day boundary).',
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
