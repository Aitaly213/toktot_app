import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toktot_app/ui/screens/registration/cubit/registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final TextEditingController phoneController = TextEditingController();
  bool acceptTerms = false;

  RegistrationCubit() : super(RegistrationInitial());

  void setPhone(String phone) {
    if (phone.length != 9) {
      emit(const RegistrationPhoneError('Заполните поле. (9 цифр)'));
    } else {
      emit(RegistrationInitial());
      validate();
    }
  }

  void setAcceptTerms(bool accept) {
    acceptTerms = accept;
    if (!accept) {
      emit(const RegistrationTermsError('Вы не приняли политику конфиденциальности.'));
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
        ? 'Вы не приняли политику конфиденциальности.'
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
    // TODO: Add OTP sending logic
  }
}