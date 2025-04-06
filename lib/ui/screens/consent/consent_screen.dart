import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktot_app/navigation/routs/routs.dart';
import 'package:toktot_app/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'consent_cubit.dart';
import 'package:flutter/gestures.dart';

/// Screen for user consent.
class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsentCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Text(
                  'Подтверждение данных',
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SvgPicture.asset(
                  'assets/images/placeholder.svg',
                  width: 323,
                  height: 240,
                ),
                const SizedBox(height: 10),
                Text(
                  'Переходя дальше, вы даете согласие на обработку данных',
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textGrey,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 84),
                BlocBuilder<ConsentCubit, bool>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: state,
                              onChanged: (value) {
                                context.read<ConsentCubit>().toggleConsent(value ?? false);
                              },
                              activeColor: AppColors.bluePrimary,
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
                                          color: AppColors.bluePrimary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final Uri url = Uri.parse(
                                              "https://www.youtube.com/watch?v=X1oxb8GiFdI");
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(
                                              url,
                                              mode: LaunchMode.externalApplication,
                                            );
                                          } else {
                                            throw "Не удалось открыть $url";
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
                          onPressed: state
                              ? () {
                            Navigator.pushNamed(context, Routs.photo);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state ? AppColors.bluePrimary : const Color(0xFF676576),
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
                              Routs.registration,
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}