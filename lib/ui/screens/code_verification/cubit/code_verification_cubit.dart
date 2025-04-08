import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../navigation/routs/app_routes.dart';

part 'code_verification_state.dart';

class CodeVerificationCubit extends Cubit<CodeVerificationState> {
  static const String correctCode = "7777";
  static const int timerDuration = 30;

  Timer? _timer;

  CodeVerificationCubit()
      : super(CodeVerificationState(
    code: List.filled(4, ''),
    controllers: List.generate(4, (_) => TextEditingController()),
    focusNodes: List.generate(4, (_) => FocusNode()),
    timer: timerDuration,
  ));

  void startTimer() {
    emit(state.copyWith(isButtonEnabled: false, timer: timerDuration));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timer > 0) {
        emit(state.copyWith(timer: state.timer - 1));
      } else {
        emit(state.copyWith(isButtonEnabled: true, timer: 0));
        _timer?.cancel();
      }
    });
  }

  void setCode(int index, String value) {
    final newCode = List<String>.from(state.code);
    newCode[index] = value;
    emit(state.copyWith(code: newCode, errorMessage: ''));

    if (value.isNotEmpty && index < 3) {
      state.focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      state.focusNodes[index - 1].requestFocus();
    }

    validateCode();
  }

  void validateCode() {
    final inputCode = state.code.join();
    if (state.code.contains('')) {
      emit(state.copyWith(errorMessage: 'Введите код.', isCodeValid: false));
    } else if (inputCode != correctCode) {
      emit(state.copyWith(errorMessage: 'Неверный код.', isCodeValid: false));
    } else {
      emit(state.copyWith(errorMessage: '', isCodeValid: true));
    }
  }

  void verifyCode(BuildContext context) {
    final inputCode = state.code.join();
    if (inputCode == correctCode) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.consent,
            (route) => false,
      );
    } else {
      emit(state.copyWith(errorMessage: 'Неправильный код верификации.'));
    }
  }

  void resendCode() {
    startTimer();
    // Здесь можно добавить вызов API для повторной отправки кода
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
