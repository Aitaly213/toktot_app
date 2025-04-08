import 'package:equatable/equatable.dart';

class ConsentState extends Equatable {
  final String username;
  final bool consentGiven;

  const ConsentState({
    this.username = '',
    this.consentGiven = false,
  });

  ConsentState copyWith({
    String? username,
    bool? consentGiven,
  }) {
    return ConsentState(
      username: username ?? this.username,
      consentGiven: consentGiven ?? this.consentGiven,
    );
  }

  @override
  List<Object?> get props => [username, consentGiven];
}