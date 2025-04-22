part of 'bank_card_payment_cubit.dart';

enum PaymentStatus { idle, success, error }

@immutable
class BankCardPaymentState {
  final List<String> savedCards;
  final String amount;
  final double balance;
  final int topUpCount;
  final PaymentStatus status;
  final String message;

  const BankCardPaymentState({
    required this.savedCards,
    required this.amount,
    required this.balance,
    required this.topUpCount,
    required this.status,
    required this.message,
  });

  factory BankCardPaymentState.initial() => BankCardPaymentState(
    savedCards: [],
    amount: '',
    balance: 0.0,
    topUpCount: 0,
    status: PaymentStatus.idle,
    message: '',
  );

  BankCardPaymentState copyWith({
    List<String>? savedCards,
    String? amount,
    double? balance,
    int? topUpCount,
    PaymentStatus? status,
    String? message,
  }) {
    return BankCardPaymentState(
      savedCards: savedCards ?? this.savedCards,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      topUpCount: topUpCount ?? this.topUpCount,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}