import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/action/drink_notifications.dart';
import 'package:remembeer/drink/controller/drink_controller.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/pages/activity_page.dart';
import 'package:remembeer/pages/drink_page.dart';
import 'package:remembeer/pages/leaderboards_page.dart';
import 'package:remembeer/pages/profile_page.dart';
import 'package:remembeer/pages/settings_page.dart';

const _drinkPageIndex = 2;

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  static const platform = MethodChannel('quick_add_action');
  int _selectedIndex = _drinkPageIndex;

  final _drinkController = get<DrinkController>();

  static final List<Widget> _pages = <Widget>[
    ProfilePage(),
    const LeaderboardsPage(),
    const DrinkPage(),
    const ActivityPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleQuickAddAction);
  }

  @override
  void dispose() {
    platform.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _handleQuickAddAction(MethodCall call) async {
    if (call.method == 'quickAddPressed') {
      await _drinkController.addDefaultDrink();

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedIndex = _drinkPageIndex;
      });
      showDefaultDrinkAdded(context);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
            _buildNavigationBar(context),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar _buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Leaderboards',
        ),
        BottomNavigationBarItem(
          icon: DrinkIcon(
            category: DrinkCategory.Beer,
            color: _selectedIndex == _drinkPageIndex
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: 'Drink',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Activity'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
