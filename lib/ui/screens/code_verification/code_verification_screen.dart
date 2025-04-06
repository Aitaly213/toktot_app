import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import 'code_verification_cubit.dart';

class CodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const CodeVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CodeVerificationCubit();
        cubit.startTimer();
        return cubit;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 140),
                  Text(
                    'Верификация кода',
                    style: GoogleFonts.comfortaa(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'На номер +996 ${widget.phoneNumber} был отправлен SMS-код, введите его.',
                    style: GoogleFonts.comfortaa(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textGrey,
                      ),
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
                    child: BlocBuilder<CodeVerificationCubit, CodeVerificationState>(
                      builder: (context, state) {
                        final cubit = context.read<CodeVerificationCubit>();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(4, (index) {
                                return Flexible(
                                  child: _buildCodeInputBox(context, cubit, state, index),
                                );
                              }),
                            ),
                            if (state.errorMessage.isNotEmpty)
                              Transform.translate(
                                offset: const Offset(0, -16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorMessage,
                                    style: GoogleFonts.comfortaa(
                                      textStyle: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
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
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: 'Изменить',
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: AppColors.bluePrimary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
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
                            ? () => context.read<CodeVerificationCubit>().verifyCode(context)
                            : state.isButtonEnabled
                            ? () => context.read<CodeVerificationCubit>().resendCode()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bluePrimary,
                          textStyle: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(
                          state.isCodeValid
                              ? 'Войти'
                              : state.isButtonEnabled
                              ? 'Запросить код заново'
                              : 'Запросить код - через ${state.timer} сек.',
                          style: GoogleFonts.comfortaa(
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputBox(BuildContext context, CodeVerificationCubit cubit,
      CodeVerificationState state, int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: state.controllers[index],
        focusNode: state.focusNodes[index]
          ..addListener(() {
            if (state.focusNodes[index].hasFocus) {
              _scrollToBottom();
            }
          }),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.bluePrimary, width: 2),
          ),
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
          contentPadding: const EdgeInsets.all(8),
        ),
        textAlign: TextAlign.center,
        style: GoogleFonts.comfortaa(
          textStyle: const TextStyle(fontSize: 24),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) => cubit.setCode(index, value),
      ),
    );
  }
}