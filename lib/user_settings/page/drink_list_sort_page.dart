import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/model/drink_list_sort.dart';
import 'package:remembeer/user_settings/service/user_settings_service.dart';
import 'package:remembeer/user_settings/widget/settings_page_template.dart';

class DrinkListSortPage extends StatefulWidget {
  const DrinkListSortPage({super.key});

  @override
  State<DrinkListSortPage> createState() => _DrinkListSortPageState();
}

class _DrinkListSortPageState extends State<DrinkListSortPage> {
  final _userSettingsService = get<UserSettingsService>();

  DrinkListSort? _selectedSort;

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Drink List Order'),
      hint:
          'Choose how drinks are sorted in the list. '
          '"Newest first" shows your most recent drinks at the top, '
          'while "Oldest first" shows them at the bottom.',
      onFabPressed: _saveSettings,
      child: AsyncBuilder(
        future: _userSettingsService.currentUserSettings,
        builder: (context, userSettings) {
          _selectedSort ??= userSettings.drinkListSort;

          return Column(
            children: DrinkListSort.values.map(_buildSortOption).toList(),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(DrinkListSort sort) {
    final isSelected = _selectedSort == sort;

    return Card(
      child: ListTile(
        leading: Radio<DrinkListSort>(
          value: sort,
          groupValue: _selectedSort,
          onChanged: (value) {
            setState(() {
              _selectedSort = value;
            });
          },
        ),
        title: Text(sort.displayName),
        subtitle: Text(_getSubtitle(sort)),
        selected: isSelected,
        onTap: () {
          setState(() {
            _selectedSort = sort;
          });
        },
      ),
    );
  }

  String _getSubtitle(DrinkListSort sort) {
    switch (sort) {
      case DrinkListSort.descending:
        return 'Most recent drinks appear at the top';
      case DrinkListSort.ascending:
        return 'Oldest drinks appear at the top';
    }
  }

  Future<void> _saveSettings() async {
    await _userSettingsService.updateDrinkListSort(_selectedSort!);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
