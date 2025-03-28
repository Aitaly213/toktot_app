import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing the consent state.
class ConsentCubit extends Cubit<bool> {
  ConsentCubit() : super(false);

  /// Toggles the consent state.
  void toggleConsent(bool value) => emit(value);
}