import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktot_app/themes/app_colors.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigation({super.key, required this.selectedIndex});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex; // Default to Home

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    const routes = [
      '/history', // Index 0
      '/home', // Index 1
      '/profile', // Index 2
    ];

    if (ModalRoute.of(context)?.settings.name != routes[index]) {
      Navigator.pushReplacementNamed(
        context,
        routes[index],
        arguments: {'selectedIndex': index}, // Передаём индекс в новый экран
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add vertical spacing
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      // Margin to create floating effect
      decoration: BoxDecoration(
        color: AppColors.lightGray, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        // Transparent since Container handles color
        elevation: 0,
        // Remove default elevation
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        // Keeps icons centered
        showSelectedLabels: false,
        // Hide labels
        showUnselectedLabels: false,
        // Hide labels
        items: [
          _buildNavItem('assets/images/ic_history.svg', 0),
          _buildNavItem('assets/images/ic_home.svg', 1),
          _buildNavItem('assets/images/ic_profile.svg', 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.blue
              : Colors.transparent, // Синий круг вокруг активного элемента
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          color: isSelected
              ? Colors.white
              : Colors.black, // Белая иконка, если активна
        ),
      ),
      label: '',
    );
  }
}
