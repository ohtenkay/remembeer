import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remembeer/pages/activity_page.dart';
import 'package:remembeer/pages/drink_page.dart';
import 'package:remembeer/pages/leaderboards_page.dart';
import 'package:remembeer/pages/profile_page.dart';
import 'package:remembeer/pages/settings_page.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;

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
            icon: SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset(
                'assets/icons/beer.svg',
                colorFilter: ColorFilter.mode(
                  _selectedIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                  BlendMode.srcIn,
                ),
              ),
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
