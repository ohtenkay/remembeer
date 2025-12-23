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
          'Choose how drinks and sessions are sorted in the list. '
          '"Newest first" shows your most recent drinks and sessions at the top, '
          'while "Oldest first" shows them at the bottom.',
      child: AsyncBuilder(
        future: _userSettingsService.currentUserSettings,
        builder: (context, userSettings) {
          _selectedSort ??= userSettings.drinkListSort;

          return RadioGroup<DrinkListSort>(
            groupValue: _selectedSort,
            onChanged: _onSortChanged,
            child: Column(
              children: DrinkListSort.values.map(_buildSortOption).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOption(DrinkListSort sort) {
    final isSelected = _selectedSort == sort;

    return Card(
      child: ListTile(
        leading: Radio<DrinkListSort>(value: sort),
        title: Text(sort.displayName),
        subtitle: Text(_getSubtitle(sort)),
        selected: isSelected,
        onTap: () => _onSortChanged(sort),
      ),
    );
  }

  String _getSubtitle(DrinkListSort sort) {
    switch (sort) {
      case DrinkListSort.descending:
        return 'Most recent drinks and sessions appear at the top';
      case DrinkListSort.ascending:
        return 'Oldest drinks and sessions appear at the top';
    }
  }

  Future<void> _onSortChanged(DrinkListSort? value) async {
    if (value == null) return;
    setState(() {
      _selectedSort = value;
    });
    await _userSettingsService.updateDrinkListSort(value);
  }
}
