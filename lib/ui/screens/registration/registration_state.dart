import 'package:equatable/equatable.dart';

// Base state class
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

// Initial state
class RegistrationInitial extends RegistrationState {}

// State with phone number error
class RegistrationPhoneError extends RegistrationState {
  final String phoneError;

  const RegistrationPhoneError(this.phoneError);

  @override
  List<Object?> get props => [phoneError];
}

// State with terms error
class RegistrationTermsError extends RegistrationState {
  final String termsError;

  const RegistrationTermsError(this.termsError);

  @override
  List<Object?> get props => [termsError];
}

// State when registration is valid
class RegistrationValid extends RegistrationState {}