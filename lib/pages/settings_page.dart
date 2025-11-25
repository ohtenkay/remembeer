import 'package:flutter/material.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink_type/widget/custom_drink_types_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user_settings/widget/default_drink_page.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading('Drinks'),
          _buildDrinkSettinsBox(context),
          const Spacer(),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.logout,
            size: 20,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: _authService.signOut,
          label: const Text(
            'SIGN OUT',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    String title,
    Widget destinationPage,
  ) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => destinationPage,
        ),
      ),
    );
  }

  Widget _buildDrinkSettinsBox(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          _buildSettingsCard(context, 'Custom drinks', CustomDrinkTypesPage()),
          const Divider(height: 1),
          _buildSettingsCard(
            context,
            'Default drink',
            const DefaultDrinkPage(),
          ),
        ],
      ),
    );
  }
}
