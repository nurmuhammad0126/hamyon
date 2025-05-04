import 'package:flutter/material.dart';
import 'package:hammyon/views/screens/home_screen.dart';
import 'package:hammyon/views/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [HomeScreen(), SettingsScreen()];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    print("\x1B[31m MAIN BUILD ISHLADI\x1B[0m");

    return Scaffold(
      body: screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
