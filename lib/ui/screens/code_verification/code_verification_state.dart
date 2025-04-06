part of 'code_verification_cubit.dart';

/// The state for the CodeVerificationCubit, contains the verification code data and UI state.
class CodeVerificationState extends Equatable {
  final List<String> code; // The entered verification code
  final List<TextEditingController> controllers; // Controllers for the input fields
  final List<FocusNode> focusNodes; // Focus nodes for the input fields
  final String errorMessage; // Error message to display
  final bool isCodeValid; // Flag indicating if the code is valid
  final bool isButtonEnabled; // Flag indicating if the resend button is enabled
  final int timer; // Countdown timer value

  CodeVerificationState({
    List<String>? code,
    List<TextEditingController>? controllers,
    List<FocusNode>? focusNodes,
    this.errorMessage = '',
    this.isCodeValid = false,
    this.isButtonEnabled = false,
    this.timer = 60,
  })  : code = code ?? List.filled(4, ''),
        controllers =
            controllers ?? List.generate(4, (index) => TextEditingController()),
        focusNodes = focusNodes ?? List.generate(4, (index) => FocusNode());

  /// Creates a copy of the current state with the given fields replaced by new values.
  CodeVerificationState copyWith({
    List<String>? code,
    List<TextEditingController>? controllers,
    List<FocusNode>? focusNodes,
    String? errorMessage,
    bool? isCodeValid,
    bool? isButtonEnabled,
    int? timer,
  }) {
    return CodeVerificationState(
      code: code ?? this.code,
      controllers: controllers ?? this.controllers,
      focusNodes: focusNodes ?? this.focusNodes,
      errorMessage: errorMessage ?? this.errorMessage,
      isCodeValid: isCodeValid ?? this.isCodeValid,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      timer: timer ?? this.timer,
    );
  }

  @override
  List<Object?> get props => [
    code,
    controllers,
    focusNodes,
    errorMessage,
    isCodeValid,
    isButtonEnabled,
    timer
  ];
}