part of 'code_verification_cubit.dart';

class CodeVerificationState extends Equatable {
  final List<String> code;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final String errorMessage;
  final bool isCodeValid;
  final bool isButtonEnabled;
  final int timer;

  const CodeVerificationState({
    required this.code,
    required this.controllers,
    required this.focusNodes,
    this.errorMessage = '',
    this.isCodeValid = false,
    this.isButtonEnabled = false,
    this.timer = 60,
  });

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
    timer,
  ];
}
