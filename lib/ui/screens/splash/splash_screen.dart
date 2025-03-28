import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_cubit.dart';

/// Screen for displaying the splash screen.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..startTimer(), // Start the timer when the cubit is created
      child: BlocListener<SplashCubit, void>(
        listener: (context, state) {
          Navigator.pushReplacementNamed(context, '/onboarding'); // Navigate to onboarding screen after timer ends
        },
        child: Scaffold(
          backgroundColor: Color(0xFF246BFD), // Background color of the splash screen
          body: Center(
            child: Text(
              'Toktot', // Application name
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}