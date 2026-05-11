import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../discover/screens/discover_screen.dart';
import '../../library/screens/library_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    DiscoverScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 300),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
              selectedIcon: const Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
              selectedIcon: const Icon(Icons.explore, color: AppColors.primary),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.video_library_outlined,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
              selectedIcon: const Icon(Icons.video_library, color: AppColors.primary),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}
