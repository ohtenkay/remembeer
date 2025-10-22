import 'package:flutter/material.dart';
import 'package:remembeer/common/beer_icon.dart';
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
  int _selectedIndex = _drinkPageIndex;

  static final List<Widget> _pages = <Widget>[
    const ProfilePage(),
    const LeaderboardsPage(),
    const DrinkPage(),
    const ActivityPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      appBar: _selectedIndex == _drinkPageIndex
          // TODO(ohtenkay): Maybe move this from AppBar to DrinkPage itself.
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Streak placeholder', style: TextStyle(fontSize: 12)),
                  Text(
                    'Create session placeholder',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: _selectedIndex == _drinkPageIndex
          ? FloatingActionButton(
              onPressed: () {
                // Action for the Drink page FAB
              },
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
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
            icon: BeerIcon(
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
      ),
    );
  }
}
