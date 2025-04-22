import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:toktot_app/navigation/routs/app_routes.dart';
import 'package:toktot_app/ui/screens/code_verification/code_verification_screen.dart';
import 'package:toktot_app/ui/screens/consent/consent_screen.dart';
import 'package:toktot_app/ui/screens/history/history_screen.dart';
import 'package:toktot_app/ui/screens/home/cubit/maps_cubit.dart';
import 'package:toktot_app/ui/screens/home/home_screen.dart';
import 'package:toktot_app/ui/screens/parking_active/cubit/parking_cubit.dart';
import 'package:toktot_app/ui/screens/parking_active/parking_active_screen.dart';
import 'package:toktot_app/ui/screens/photo/photo_screen.dart';
import 'package:toktot_app/ui/screens/profile/profile_screen.dart';
import 'package:toktot_app/ui/screens/registration/registration_screen.dart';
import 'package:toktot_app/ui/screens/splash/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔐 Загружаем .env
  await dotenv.load(fileName: ".env");

  // 🔔 Инициализация уведомлений
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const Navigation());
}
class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MapsCubit()..getLocationUpdates(Location())),
        BlocProvider(create: (_) => ParkingCubit()..startClock()),
      ],
      child: MaterialApp(
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
          AppRoutes.parkingActive: (_) => const ParkingActiveScreen(),
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
      ),
    );
  }
}
