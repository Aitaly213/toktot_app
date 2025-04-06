import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final TextEditingController phoneController = TextEditingController();
  bool acceptTerms = false;

  RegistrationCubit() : super(RegistrationInitial());

  void setPhone(String phone) {
    if (phone.length != 9) {
      emit(RegistrationPhoneError('Заполните поле. (9 цифр)'));
    } else {
      emit(RegistrationInitial());
      validate();
    }
  }

  void setAcceptTerms(bool accept) {
    acceptTerms = accept;
    if (!accept) {
      emit(RegistrationTermsError('Необходимо принять политику конфиденциальности'));
    } else {
      emit(RegistrationInitial());
      validate();
    }
  }

  void validate() {
    final phoneError = phoneController.text.replaceAll(RegExp(r'\D'), '').length != 9
        ? 'Заполните поле. (9 цифр)'
        : null;
    final termsError = !acceptTerms
        ? 'Необходимо принять политику конфиденциальности'
        : null;

    if (phoneError == null && termsError == null) {
      emit(RegistrationValid());
    } else {
      if (phoneError != null) emit(RegistrationPhoneError(phoneError));
      if (termsError != null) emit(RegistrationTermsError(termsError));
    }
  }

  void validateAndSubmit(BuildContext context) {
    validate();
    if (state is RegistrationValid) {
      final phoneNumber = phoneController.text;
      Navigator.pushNamed(
        context,
        '/code-verification',
        arguments: phoneNumber,
      );
    }
  }

  Future<void> sendOtpCode() async {
    // Implement your Firebase OTP code sending logic here
  }
}