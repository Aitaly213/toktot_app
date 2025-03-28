import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'code_verification_state.dart';

/// The `CodeVerificationCubit` handles the state and logic for the code verification process.
class CodeVerificationCubit extends Cubit<CodeVerificationState> {
  static const String correctCode = "7777"; // The correct verification code
  static const int timerDuration = 60; // The duration of the countdown timer in seconds

  Timer? _timer;

  CodeVerificationCubit()
      : super(CodeVerificationState(
    code: List<String>.filled(4, ''), // Initialize the code with empty strings
    controllers: List<TextEditingController>.generate(
        4, (index) => TextEditingController()), // Generate text controllers for input fields
    focusNodes: List<FocusNode>.generate(
        4, (index) => FocusNode()), // Generate focus nodes for input fields
    timer: timerDuration, // Initialize the timer duration
  )) {
    _startTimer(); // Start the countdown timer
  }

  /// Starts the countdown timer and updates the state accordingly.
  void _startTimer() {
    emit(state.copyWith(isButtonEnabled: false, timer: timerDuration));
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.timer > 0) {
        emit(state.copyWith(timer: state.timer - 1));
      } else {
        emit(state.copyWith(isButtonEnabled: true));
        _timer?.cancel();
      }
    });
  }

  /// Sets the verification code at the given index and manages focus.
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

  /// Validates the entered verification code.
  void validateCode() {
    final inputCode = state.code.join();
    if (state.code.contains('')) {
      emit(state.copyWith(
          errorMessage: 'Ячейки не должны быть пустыми.', isCodeValid: false));
    } else if (inputCode != correctCode) {
      emit(state.copyWith(
          errorMessage: 'Неправильный код верификации.', isCodeValid: false));
    } else {
      emit(state.copyWith(errorMessage: '', isCodeValid: true));
    }
  }

  /// Verifies the entered code and navigates to the home screen if correct.
  void verifyCode(BuildContext context) {
    final inputCode = state.code.join();
    if (inputCode == correctCode) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    } else {
      emit(state.copyWith(errorMessage: 'Неправильный код верификации.'));
    }
  }

  /// Resends the verification code and restarts the timer.
  void resendCode() {
    _startTimer();
    // Add logic to resend the code here
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}