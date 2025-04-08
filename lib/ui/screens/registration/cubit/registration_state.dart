import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationPhoneError extends RegistrationState {
  final String phoneError;

  const RegistrationPhoneError(this.phoneError);

  @override
  List<Object?> get props => [phoneError];
}

class RegistrationTermsError extends RegistrationState {
  final String termsError;

  const RegistrationTermsError(this.termsError);

  @override
  List<Object?> get props => [termsError];
}

class RegistrationValid extends RegistrationState {}
