import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktot_app/navigation/routs/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../themes/app_colors.dart';
import 'cubit/consent_cubit.dart';
import 'package:flutter/gestures.dart';
import 'cubit/consent_state.dart';

class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConsentCubit(),
      child: BlocBuilder<ConsentCubit, ConsentState>(
        builder: (context, state) {
          final cubit = context.read<ConsentCubit>();

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Введите ваше имя',
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/images/consent.jpg',
                      width: 323,
                      height: 240,
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'Переходя дальше, вы даете согласие на обработку данных',
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: AppColors.blueGray,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    TextField(
                      controller: cubit.usernameController,
                      onChanged: cubit.setUsername,
                      decoration: InputDecoration(
                        hintText: 'Ваше имя',
                        hintStyle: GoogleFonts.comfortaa(),
                        filled: true,
                        fillColor: const Color(0xFFF1F1F1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: state.username.trim().isEmpty ? Colors.red : Colors.transparent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: state.username.trim().isEmpty ? Colors.red : AppColors.blue,
                          ),
                        ),
                        errorText: state.username.trim().isEmpty ? 'Заполните поле' : null,
                      ),
                      style: GoogleFonts.comfortaa(),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        Checkbox(
                          value: state.consentGiven,
                          onChanged: (value) => cubit.toggleConsent(value ?? false),
                          activeColor: AppColors.blue,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'Я согласен(а) на ',
                              style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'обработку данных',
                                  style: GoogleFonts.comfortaa(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse("https://www.youtube.com/watch?v=X1oxb8GiFdI");
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      } else {
                                        throw "Не удалось открыть \$url";
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: ' моего автомобиля',
                                  style: GoogleFonts.comfortaa(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: state.username.trim().isNotEmpty && state.consentGiven
                          ? () {
                        Navigator.pushNamed(context, AppRoutes.photo);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.username.trim().isNotEmpty && state.consentGiven
                            ? AppColors.blue
                            : const Color(0xFF676576),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        'Далее',
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.registration,
                              (Route<dynamic> route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Colors.black38),
                      ),
                      child: Text(
                        'Назад',
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}