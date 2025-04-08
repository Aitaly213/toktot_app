import 'package:flutter/material.dart';
import 'package:toktot_app/ui/screens/code_verification/code_verification_screen.dart';
import 'package:toktot_app/ui/screens/consent/consent_screen.dart';
import 'package:toktot_app/ui/screens/history/history_screen.dart';
import 'package:toktot_app/ui/screens/home/home_screen.dart';
import 'package:toktot_app/ui/screens/photo/photo_screen.dart';
import 'package:toktot_app/ui/screens/profile/profile_screen.dart';
import 'package:toktot_app/ui/screens/registration/registration_screen.dart';
import 'package:toktot_app/ui/screens/splash/splash_screen.dart';
import 'package:toktot_app/navigation/routs/app_routes.dart';

void main() {
  runApp(const Navigation());
}

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toktot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Comfortaa',
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.registration: (_) => const RegistrationScreen(),
        AppRoutes.consent: (_) => const ConsentScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.history: (_) => const HistoryScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.photo: (_) => const PhotoScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.codeVerification) {
          final phoneNumber = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => CodeVerificationScreen(phoneNumber: phoneNumber),
          );
        }
        return null;
      },
    );
  }
}
