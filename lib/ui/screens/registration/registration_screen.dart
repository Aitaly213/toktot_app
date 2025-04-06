import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktot_app/navigation/routs/routs.dart';
import 'package:url_launcher/url_launcher.dart';

import 'registration_cubit.dart';
import 'registration_state.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/PhoneInputFormatter.dart';

/// Screen for user registration.
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocBuilder<RegistrationCubit, RegistrationState>(
            builder: (context, state) {
              final cubit = context.read<RegistrationCubit>();

              return SingleChildScrollView(
                child: Padding(
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
                                context, Routs.home, (route) => false);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Пропустить',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                              const SizedBox(width: 10),
                              SvgPicture.asset('assets/icons/skip.svg'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Авторизация',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Введите номер телефона, чтобы \nвойти или зарегистрироваться',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 23),
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/placeholder.svg',
                          width: 235,
                          height: 182,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Номер телефона',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: cubit.phoneController,
                        decoration: InputDecoration(
                          hintText: '(XXX) XX-XX-XX',
                          filled: true,
                          fillColor: const Color(0xFFF1F1F1),
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
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: state is RegistrationPhoneError
                                  ? Colors.red
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          prefixText: '+996 ',
                          prefixStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
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
                        onChanged: (value) => cubit
                            .setPhone(phoneMaskFormatter.getUnmaskedText()),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: cubit.acceptTerms,
                            onChanged: (value) =>
                                cubit.setAcceptTerms(value ?? false),
                            activeColor: AppColors.bluePrimary,
                            checkColor: Colors.white,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                      text: "Я прочитал(а) и принимаю "),
                                  TextSpan(
                                    text: "политику конфиденциальности",
                                    style: const TextStyle(
                                      color: AppColors.bluePrimary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final Uri url = Uri.parse(
                                            "https://www.youtube.com/watch?v=X1oxb8GiFdI");
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          throw "Не удалось открыть $url";
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
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
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
                              ? AppColors.bluePrimary
                              : AppColors.disableGrey,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          'Получить код SMS',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
