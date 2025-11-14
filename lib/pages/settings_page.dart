import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      child: Center(child: Text('Settings Page')),
    );
  }
}
