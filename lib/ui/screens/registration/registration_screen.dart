import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toktot_app/ui/screens/registration/registration_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen for user registration.
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<RegistrationCubit, RegistrationState>(
                builder: (context, state) {
                  final cubit = context.read<RegistrationCubit>();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Регистрация', // Registration title
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Простой старт — удобная парковка в один клик!', // Description text
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/first.png', // Ensure this file exists
                        width: 236,
                        height: 182,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: state.usernameController,
                        decoration: InputDecoration(
                          labelText: 'Имя пользователя', // Username label
                          errorText: state.usernameError,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: cubit.setUsername,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: state.phoneController,
                        decoration: InputDecoration(
                          labelText: 'Номер телефона', // Phone number label
                          hintText: '777 777 777',
                          border: const OutlineInputBorder(),
                          prefixText: '+996 | ',
                          prefixStyle: const TextStyle(color: Colors.black),
                          errorText: state.phoneError,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        onChanged: cubit.setPhone,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: state.acceptTerms,
                            onChanged: (value) =>
                                cubit.setAcceptTerms(value ?? false), // Accept terms checkbox
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                                children: [
                                  const TextSpan(
                                      text: "Я прочитал(а) и принимаю "),
                                  TextSpan(
                                    text: "политику конфиденциальности", // Privacy policy text
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final Uri url =
                                        Uri.parse("https://www.youtube.com/watch?v=X1oxb8GiFdI");
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url,
                                              mode: LaunchMode
                                                  .externalApplication); // Launch privacy policy URL
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
                      if (state.termsError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.termsError!, // Display terms error
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => cubit.validateAndSubmit(context), // Validate and submit form
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          'Получить код', // Button text
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}