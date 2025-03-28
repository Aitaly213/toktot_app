import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'registration_state.dart';

/// Cubit for managing the registration process.
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit()
      : super(RegistrationState(
    usernameController: TextEditingController(), // Controller for username input field
    phoneController: TextEditingController(), // Controller for phone input field
    acceptTerms: false, // Initial state for terms acceptance
  ));

  /// Sets the username and validates it.
  void setUsername(String username) {
    state.usernameController.text = username;
    emit(state.copyWith(
      usernameError: username.isEmpty ? 'Поле не может быть пустым' : null, // Error if username is empty
    ));
  }

  /// Sets the phone number and validates it.
  void setPhone(String phone) {
    state.phoneController.text = phone;
    emit(state.copyWith(
      phoneError: phone.length != 9 ? 'Телефон должен содержать 9 цифр' : null, // Error if phone number is not 9 digits
    ));
  }

  /// Sets the terms acceptance state and validates it.
  void setAcceptTerms(bool accept) {
    emit(state.copyWith(
      acceptTerms: accept,
      termsError:
      !accept ? 'Необходимо принять политику конфиденциальности' : null, // Error if terms are not accepted
    ));
  }

  /// Validates the input fields and navigates to the code verification screen if valid.
  void validateAndSubmit(BuildContext context) {
    final usernameError = state.usernameController.text.isEmpty
        ? 'Поле не может быть пустым'
        : null;
    final phoneError = state.phoneController.text.length != 9
        ? 'Телефон должен содержать 9 цифр'
        : null;
    final termsError = !state.acceptTerms
        ? 'Необходимо принять политику конфиденциальности'
        : null;

    emit(state.copyWith(
      usernameError: usernameError,
      phoneError: phoneError,
      termsError: termsError,
    ));

    if (usernameError == null && phoneError == null && termsError == null) {
      // Navigate to the code verification screen
      Navigator.pushNamed(context, '/code-verification');
    }
  }
}