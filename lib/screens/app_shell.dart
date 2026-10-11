import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'cart_lists_screen.dart';
import 'profile_screen.dart';
import '../core/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  final pages = const [
    HomeScreen(),
    StatsScreen(),
    SizedBox(),
    CartListsScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: pages),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: const Border(top: BorderSide(color: OwlColors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(0, Icons.home_outlined, 'Home'),
            _item(1, Icons.bar_chart_rounded, 'Stats'),
            IconButton.filled(
              onPressed: () => Navigator.pushNamed(context, '/add'),
              style: IconButton.styleFrom(
                backgroundColor: OwlColors.navy,
                foregroundColor: OwlColors.gold,
              ),
              icon: const Icon(Icons.add_rounded, size: 27),
            ),
            _item(3, Icons.shopping_cart_outlined, 'Cart'),
            _item(4, Icons.person_outline_rounded, 'Profile'),
          ],
        ),
      ),
    ),
  );
  Widget _item(int i, IconData icon, String label) => InkWell(
    onTap: () => setState(() => index = i),
    child: SizedBox(
      width: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 21,
            color: index == i ? OwlColors.navy : OwlColors.muted,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: index == i ? OwlColors.navy : OwlColors.muted,
              fontWeight: index == i ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
