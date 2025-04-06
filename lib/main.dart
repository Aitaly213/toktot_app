import 'package:flutter/material.dart';
import 'package:toktot_app/ui/screens/code_verification/code_verification_screen.dart';
import 'package:toktot_app/ui/screens/consent/consent_screen.dart';
import 'package:toktot_app/ui/screens/home/home_screen.dart';
import 'package:toktot_app/ui/screens/registration/registration_screen.dart';
import 'package:toktot_app/ui/screens/splash/splash_screen.dart';
import 'package:toktot_app/ui/screens/user_name/username_screen.dart';
import 'navigation/routs/routs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routs.splash,
      onGenerateRoute: (settings) {
        final routeBuilder = _routeBuilders[settings.name];
        if (routeBuilder != null) {
          return MaterialPageRoute(
            builder: (_) => routeBuilder(settings.arguments),
          );
        }
        return null; // Return null for unknown routes
      },
    );
  }

  Map<String, Widget Function(Object?)> get _routeBuilders {
    return {
      Routs.splash: (_) => const SplashScreen(),
      Routs.registration: (_) => const RegistrationScreen(),
      Routs.consent: (_) => const ConsentScreen(),
      Routs.codeVerification: (args) {
        final phoneNumber = args as String;
        return CodeVerificationScreen(phoneNumber: phoneNumber);
      },
      Routs.userName: (_) => UsernameScreen(),
      Routs.home: (_) => const HomeScreen(),
      Routs.home: (_) => const HomeScreen(),
    };
  }
}