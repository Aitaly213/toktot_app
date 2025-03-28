import 'package:flutter/material.dart';
import 'package:toktot_app/ui/screens/home/home_screen.dart';
import 'package:toktot_app/ui/screens/onboard/onboarding_screen.dart';
import 'package:toktot_app/ui/screens/registration/code_verification/code_verification_screen.dart';
import 'package:toktot_app/ui/screens/registration/consent/consent_screen.dart';
import 'package:toktot_app/ui/screens/registration/registration_screen.dart';
import 'package:toktot_app/ui/screens/splash/splash_screen.dart';

void main() {
  runApp(const Navigation());
}

/// The main widget for the navigation system of the app.
class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokto', // The title of the application
      theme: ThemeData(
        primarySwatch: Colors.blue, // The primary color theme
      ),
      initialRoute: '/', // The initial route of the app
      routes: {
        '/': (context) => const SplashScreen(), // Route for the SplashScreen
        '/onboarding': (context) => const OnboardingScreen(), // Route for the OnboardingScreen
        '/consent': (context) => const ConsentScreen(), // Route for the ConsentScreen
        '/registration': (context) => const RegistrationScreen(), // Route for the RegistrationScreen
        '/code-verification': (context) => const CodeVerificationScreen(), // Route for the CodeVerificationScreen
        '/home': (context) => const HomeScreen(), // Route for the HomeScreen
      },
    );
  }
}