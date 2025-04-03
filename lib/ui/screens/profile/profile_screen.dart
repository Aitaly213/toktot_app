import 'package:flutter/material.dart';

import '../../widgets/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigation(),
          body: Center(
            child: Text('Profile Screen'),
          )),
    );
  }
}
