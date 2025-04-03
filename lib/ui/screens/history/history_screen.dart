import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/bottom_nav.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigation(),
          body: Center(
            child: Text('History Screen'),
          )),
    );
  }
}
