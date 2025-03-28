part of 'registration_cubit.dart';

/// The state for the RegistrationCubit, contains the data for the registration process.
class RegistrationState extends Equatable {
  final TextEditingController
      usernameController; // Controller for username input field
  final TextEditingController
      phoneController; // Controller for phone input field
  final bool acceptTerms; // State for terms acceptance
  final String? usernameError; // Error message for username validation
  final String? phoneError; // Error message for phone validation
  final String? termsError; // Error message for terms acceptance validation

  RegistrationState({
    required this.usernameController,
    required this.phoneController,
    required this.acceptTerms,
    this.usernameError,
    this.phoneError,
    this.termsError,
  });

  /// Creates a copy of the current state with the given fields replaced by new values.
  RegistrationState copyWith({
    TextEditingController? usernameController,
    TextEditingController? phoneController,
    bool? acceptTerms,
    String? usernameError,
    String? phoneError,
    String? termsError,
  }) {
    return RegistrationState(
      usernameController: usernameController ?? this.usernameController,
      phoneController: phoneController ?? this.phoneController,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      usernameError: usernameError,
      phoneError: phoneError,
      termsError: termsError,
    );
  }

  @override
  List<Object?> get props => [
        usernameController,
        phoneController,
        acceptTerms,
        usernameError,
        phoneError,
        termsError,
      ];
}
