import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'code_verification_cubit.dart';

/// The screen for the code verification process.
class CodeVerificationScreen extends StatelessWidget {
  const CodeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CodeVerificationCubit(),
      child: WillPopScope(
        onWillPop: () async => false, // Disable back navigation
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Верификация кода', // Title of the app bar
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/first.png', // Image asset
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Введите код, отправленный на ваш номер телефона.', // Instruction text
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    BlocBuilder<CodeVerificationCubit, CodeVerificationState>(
                      builder: (context, state) {
                        final cubit = context.read<CodeVerificationCubit>();

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                  4,
                                      (index) => _buildCodeInputBox(
                                      context, cubit, state, index)), // Input boxes for code entry
                            ),
                            if (state.errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  state.errorMessage, // Error message display
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    BlocBuilder<CodeVerificationCubit, CodeVerificationState>(
                      builder: (context, state) {
                        return state.isCodeValid
                            ? ElevatedButton(
                          onPressed: () {
                            context
                                .read<CodeVerificationCubit>()
                                .verifyCode(context); // Verify code on button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text(
                            'Подтвердить',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Container();
                      },
                    ),
                    SizedBox(height: 10),
                    BlocBuilder<CodeVerificationCubit, CodeVerificationState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: state.isButtonEnabled
                                  ? () {
                                context
                                    .read<CodeVerificationCubit>()
                                    .resendCode(); // Resend code on button press
                              }
                                  : null,
                              child: Text(
                                'Получить код повторно',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            if (!state.isButtonEnabled)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '(${state.timer}s)', // Timer display
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Изменить',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context); // Navigate back to change phone number
                              },
                          ),
                          TextSpan(text: ' номер телефона '),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
          border: OutlineInputBorder(),
          errorText: state.errorMessage.isNotEmpty ? '' : null,
        ),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          cubit.setCode(index, value); // Update code on input change
        },
      ),
    );
  }
}