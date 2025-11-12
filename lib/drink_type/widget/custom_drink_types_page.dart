import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/widget/custom_drink_type_list.dart';

class CustomDrinkTypesPage extends StatelessWidget {
  const CustomDrinkTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text('Custom Drink Types'),
      child: CustomDrinkTypeList(),
    );
  }
}
