import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../navigation/routs/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Плавное появление текста/лого
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Переход на регистрацию
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.registration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF246BFD),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          child: Text(
            'Toktot',
            style: GoogleFonts.comfortaa(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 👉 Хочешь заменить текст на лого — просто замени child:
          // child: SvgPicture.asset('assets/images/logo.svg', width: 120, height: 120),
        ),
      ),
    );
  }
}