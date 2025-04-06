import 'package:flutter/material.dart';

import '../../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int selectedIndex = args?['selectedIndex'] ?? 1;



    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigation(selectedIndex: selectedIndex,),
          body: Center(
            child: Text('Profile Screen'),
          )),
    );
  }
}
