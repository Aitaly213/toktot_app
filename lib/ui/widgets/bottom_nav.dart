import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktot_app/themes/app_colors.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final int blurRadius;
  final int spreadRadius;

  const BottomNavigation({super.key, required this.selectedIndex, this.blurRadius = 0,this.spreadRadius = 0});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex; // Default to Home
  late int _blurRadius;
  late int _spreadRadius;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _blurRadius = widget.blurRadius;
    _spreadRadius = widget.spreadRadius;
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: _blurRadius.toDouble(),
            spreadRadius: _spreadRadius.toDouble(),
          )
        ]
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('assets/images/ic_history.svg', 0),
          _buildNavItem('assets/images/ic_home.svg', 1),
          _buildNavItem('assets/images/ic_profile.svg', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.blue : Colors.transparent,
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

}
