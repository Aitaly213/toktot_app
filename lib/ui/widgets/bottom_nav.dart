import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      const routes = [
        '/history',  // Индекс 0
        '/home',   // Индекс 1
        '/profile', // Индекс 2
      ];

      // Навигация с заменой текущего экрана
      if (ModalRoute.of(context)?.settings.name != routes[index]) {
        Navigator.pushReplacementNamed(context, routes[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/ic_history.svg',
            semanticsLabel: "",
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/ic_home.svg',
            semanticsLabel: "",
            color: Colors.black,
          ),
          label: 'Home',
        ),
         BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/ic_profile.svg',
            semanticsLabel: "",
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
