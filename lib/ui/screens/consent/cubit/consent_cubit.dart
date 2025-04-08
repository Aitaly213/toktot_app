import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'consent_state.dart';

class ConsentCubit extends Cubit<ConsentState> {
  final TextEditingController usernameController = TextEditingController();

  ConsentCubit() : super(const ConsentState());

  void setUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void toggleConsent(bool consentGiven) {
    emit(state.copyWith(consentGiven: consentGiven));
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    return super.close();
  }
}