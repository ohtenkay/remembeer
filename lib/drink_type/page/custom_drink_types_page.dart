import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/settings_page_template.dart';
import 'package:remembeer/drink_type/page/add_drink_type_page.dart';
import 'package:remembeer/drink_type/widget/custom_drink_type_list.dart';

class CustomDrinkTypesPage extends StatelessWidget {
  const CustomDrinkTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPageTemplate(
      title: const Text('Custom Drink Types'),
      fabIcon: Icons.add,
      onFabPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (context) => AddDrinkTypePage())),
      child: CustomDrinkTypeList(),
    );
  }
}
