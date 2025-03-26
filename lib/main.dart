import 'package:flutter/material.dart';
import 'package:toktot_app/ui/screens/onboard/onboarding_screen.dart';
import 'package:toktot_app/ui/screens/registration/registration_screen.dart';
import 'package:toktot_app/ui/screens/splash/splash_screen.dart';
 // Assuming you have a registration screen

void main() {
  runApp(Navigation());
}

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/registration': (context) => RegistrationScreen(), // Assuming you have a registration screen
      },
    );
  }
}

