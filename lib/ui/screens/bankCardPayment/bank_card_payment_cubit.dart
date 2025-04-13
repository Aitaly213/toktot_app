import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'bank_card_payment_state.dart';

class BankCardPaymentCubit extends Cubit<BankCardPaymentState> {
  BankCardPaymentCubit() : super(BankCardPaymentState.initial());

  void updateAmount(String value) {
    emit(state.copyWith(amount: value));
  }

  void processCardPayment({
    required String cardNumber,
    required String expiry,
    required String cvv,
    required String amount,
  }) {
    final isValidCard = cardNumber.length >= 16 &&
        expiry.isNotEmpty &&
        cvv.length >= 3;

    final isValidAmount = double.tryParse(amount) != null &&
        double.parse(amount) > 0;

    if (!isValidCard || !isValidAmount) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        message: 'Проверьте введенные данные (все поля обязательны, сумма должна быть положительной)',
      ));
      return;
    }

    final isAccepted = Random().nextBool();

    if (isAccepted) {
      final last4 = cardNumber.substring(cardNumber.length - 4);
      final updatedCards = List<String>.from(state.savedCards)..add(last4);
      emit(state.copyWith(
        savedCards: updatedCards,
        status: PaymentStatus.success,
        message: 'Карта успешно добавлена',
      ));
    } else {
      emit(state.copyWith(
        status: PaymentStatus.error,
        message: 'Карта не принята, попробуйте другую',
      ));
    }
  }

  void processBalanceTopUp(String sum) {
    final value = double.tryParse(sum);
    if (state.savedCards.isEmpty) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        message: 'Добавьте карту для пополнения баланса',
      ));
      return;
    }
    if (value == null || value <= 0) {
      emit(state.copyWith(
        status: PaymentStatus.error,
        message: 'Введите корректную сумму (только положительные числа)',
      ));
    } else {
      emit(state.copyWith(
        balance: state.balance + value,
        topUpCount: state.topUpCount + 1,
        status: PaymentStatus.success,
        message: 'Баланс пополнен',
      ));
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: PaymentStatus.idle, message: ''));
  }
}