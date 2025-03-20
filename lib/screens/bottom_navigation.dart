import 'package:finance_app/screens/trans.dart';
import 'package:finance_app/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/firebase_auth.dart';
import 'auth_screen.dart';
import 'finance_overview.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const Trans(),
    const FinanceOverviewScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Transaction'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: 'Overview'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          appBar: AppBar(
            title: const Row(
              children: [
                Text('FIN',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 28)),
                Text(
                  'APP',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 28),
                )
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _authService.signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                    );
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          body: _screens[_selectedIndex]),
    );
  }
}
