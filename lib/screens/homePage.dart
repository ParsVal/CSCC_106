import 'package:flutter/material.dart';
import 'package:otero_mandy_new/screens/loginScreen.dart';
import 'dashboard.dart';
import 'listofUsers.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: HomePageHome(),
    );
  }
}

class HomePageHome extends StatefulWidget {
  @override
  State<HomePageHome> createState() => _HomePageHomeState();
}

class _HomePageHomeState extends State<HomePageHome> {
  int selectedIndex = 0;

  final List<_NavItem> navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.people_alt_rounded, label: 'Users'),
  ];

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Screens built inside build() so callbacks are always fresh
    final List<Widget> screens = [
      Dashboard(
        onGoToUsers: () => setState(() => selectedIndex = 1),
        onLogout: _logout,
      ),
      Listofusers(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.07), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isActive = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF0EA5E9).withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              item.icon,
                              key: ValueKey(isActive),
                              color: isActive
                                  ? const Color(0xFF0EA5E9)
                                  : Colors.white.withOpacity(0.35),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: isActive
                                  ? const Color(0xFF0EA5E9)
                                  : Colors.white.withOpacity(0.35),
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            child: Text(item.label),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}