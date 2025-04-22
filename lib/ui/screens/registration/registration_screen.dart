import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/navigation/routs/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../themes/app_colors.dart';
import 'cubit/registration_cubit.dart';
import 'cubit/registration_state.dart';
import '../../../utils/input_formatter.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocBuilder<RegistrationCubit, RegistrationState>(
              builder: (context, state) {
                final cubit = context.read<RegistrationCubit>();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<RegistrationCubit>(context).close();
                            Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.home, (route) => false);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Пропустить',
                                style: GoogleFonts.comfortaa(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SvgPicture.asset('assets/icons/skip.svg'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Авторизация',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Введите номер телефона, чтобы \nвойти или зарегистрироваться',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: AppColors.blueGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 23),
                      Center(
                        child:
                          Image.asset(
                            'assets/images/registration.jpg',
                            width: 235,
                            height: 182,
                          )
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Номер телефона',
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: cubit.phoneController,
                        decoration: InputDecoration(
                          hintText: '(XXX) XX-XX-XX',
                          filled: true,
                          fillColor: const Color(0xFFF1F1F1),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 15),
                            child: Text(
                              '+996',
                              style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: state is RegistrationPhoneError
                                  ? Colors.red
                                  : Colors.transparent,
                              width: state is RegistrationPhoneError ? 1 : 0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: state is RegistrationPhoneError
                                  ? Colors.red
                                  : AppColors.blue,
                              width: 1,
                            ),
                          ),
                          errorText: state is RegistrationPhoneError
                              ? (state as RegistrationPhoneError).phoneError
                              : null,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                          phoneMaskFormatter,
                        ],
                        onChanged: (value) =>
                            cubit.setPhone(phoneMaskFormatter.getUnmaskedText()),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: cubit.acceptTerms,
                            onChanged: (value) =>
                                cubit.setAcceptTerms(value ?? false),
                            activeColor: AppColors.blue,
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.comfortaa(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                children: [
                                  const TextSpan(text: "Я прочитал(а) и принимаю "),
                                  TextSpan(
                                    text: "политику конфиденциальности",
                                    style: GoogleFonts.comfortaa(
                                      textStyle: const TextStyle(
                                        color: AppColors.blue,
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
                                          throw "Не удалось открыть \$url";
                                        }
                                      },
                                  ),
                                  const TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state is RegistrationTermsError)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            (state as RegistrationTermsError).termsError,
                            style: GoogleFonts.comfortaa(
                              textStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: state is RegistrationValid
                            ? () {
                          cubit.validateAndSubmit(context);
                          cubit.sendOtpCode();
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is RegistrationValid
                              ? AppColors.blue
                              : AppColors.blueGray,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        child: Text(
                          'Получить код SMS',
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}