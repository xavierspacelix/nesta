import 'package:flutter/material.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/features/dashboard/screens/dashboard_screen.dart';
import 'package:nesta/features/schedule/screens/schedule_screen.dart';
import 'package:nesta/features/finance/screens/financial_dashboard_screen.dart';
import 'package:nesta/features/activity/screens/activity_feed_screen.dart';
import 'package:nesta/features/members/screens/members_screen.dart';
 
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ScheduleScreen(),
    const ActivityFeedScreen(),
    const FinancialDashboardScreen(),
    const MembersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 16,
        shadowColor: AppTheme.neutral200.withOpacity(0.5),
        indicatorColor: AppTheme.primary.withOpacity(0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.cleaning_services_outlined),
            selectedIcon: Icon(Icons.cleaning_services_rounded, color: AppTheme.primary),
            label: 'Chores',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded, color: AppTheme.primary),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primary),
            label: 'Finance',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_alt_rounded, color: AppTheme.primary),
            label: 'Members',
          ),
        ],
      ),
    );
  }
}
