import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import 'code_verification_cubit.dart';

/// The screen for the code verification process.
class CodeVerificationScreen extends StatelessWidget {
  final String phoneNumber;

  const CodeVerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          final cubit = CodeVerificationCubit();
          cubit.startTimer(); // Start the timer when the screen is created
          return cubit;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 140,),
                    const Text(
                      'Верификация кода',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'На номер +996 $phoneNumber был отправлен SMS-код, введите его.',
                      // Instruction text
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SvgPicture.asset(
                      'assets/images/placeholder.svg',
                      width: 235,
                      height: 182,
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: BlocBuilder<CodeVerificationCubit,
                          CodeVerificationState>(
                        builder: (context, state) {
                          final cubit = context.read<CodeVerificationCubit>();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // Align items to the center
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    4,
                                    (index) => Flexible(
                                          child: _buildCodeInputBox(
                                              context,
                                              cubit,
                                              state,
                                              index), // Input boxes for code entry
                                        )),
                              ),
                              if (state.errorMessage.isNotEmpty)
                                Transform.translate(
                                  offset: const Offset(0, -16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.errorMessage,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Изменить',
                            style: const TextStyle(
                              color: AppColors.bluePrimary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(
                                    context); // Navigate back to change phone number
                              },
                          ),
                          const TextSpan(text: ' номер телефона '),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<CodeVerificationCubit, CodeVerificationState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state.isCodeValid
                              ? () {
                                  context
                                      .read<CodeVerificationCubit>()
                                      .verifyCode(
                                          context); // Verify code on button press
                                }
                              : state.isButtonEnabled
                                  ? () {
                                      context
                                          .read<CodeVerificationCubit>()
                                          .resendCode(); // Resend code on button press
                                    }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bluePrimary,
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            state.isCodeValid
                                ? 'Войти'
                                : state.isButtonEnabled
                                    ? 'Запросить код заново'
                                    : 'Запросить код - через ${state.timer} сек.',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  /// Builds an individual code input box.
  Widget _buildCodeInputBox(BuildContext context, CodeVerificationCubit cubit,
      CodeVerificationState state, int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: state.controllers[index],
        focusNode: state.focusNodes[index],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.bluePrimary, width: 2),
          ),
          // Когда поле не активно
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorText: state.errorMessage.isNotEmpty ? '' : null,
          isDense: true,
          contentPadding:
              const EdgeInsets.all(8), // Контролируем внутреннее пространство
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          cubit.setCode(index, value); // Обновление цифры кода
        },
      ),
    );
  }
}
