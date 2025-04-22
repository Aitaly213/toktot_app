// --- Screen (bank_card_payment_screen.dart) ---
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/ui/screens/bankCardPayment/widgets/showCvvConfirmationDialog.dart';
import 'package:toktot_app/ui/screens/bankCardPayment/widgets/showResultDialog.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/input_formatter.dart';
import 'bank_card_payment_cubit.dart';

class BankCardPaymentScreen extends StatefulWidget {
  const BankCardPaymentScreen({super.key});

  @override
  State<BankCardPaymentScreen> createState() => _BankCardPaymentScreenState();
}

class _BankCardPaymentScreenState extends State<BankCardPaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _amountController = TextEditingController();
  final _sumInputController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    _sumInputController.dispose();
    super.dispose();
  }

  void _showAddCardDialog(BuildContext context) {
    final cubit = context.read<BankCardPaymentCubit>();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Добавьте карту',
                        style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Это позволит быстрее пополнять баланс\nбез необходимости вводить данные каждый раз.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comfortaa(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [cardNumberFormatter],
                      decoration: _inputDecoration('Номер карты'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryDateController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [expiryDateFormatter],
                            decoration: _inputDecoration('MM/ГГ'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [cvvFormatter],
                            decoration: _inputDecoration('CVV'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        cubit.processCardPayment(
                          cardNumber: cardNumberFormatter.getUnmaskedText(),
                          expiry: _expiryDateController.text,
                          cvv: _cvvController.text,
                          amount: '1',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text('Добавить', style: GoogleFonts.comfortaa(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.comfortaa(color: Colors.grey.shade500),
    filled: true,
    fillColor: const Color(0xFFF1F1F1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BankCardPaymentCubit(),
      child: BlocConsumer<BankCardPaymentCubit, BankCardPaymentState>(
        listener: (context, state) {
          if (state.status != PaymentStatus.idle) {
            showResultDialog(
              context: context,
              success: state.status == PaymentStatus.success,
              message: state.message,
            );
            context.read<BankCardPaymentCubit>().resetStatus();
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 20),
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 12),
                            Text('Пополнение картой', style: GoogleFonts.comfortaa(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Текущий баланс', style: GoogleFonts.comfortaa(fontSize: 12, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('${state.balance.toStringAsFixed(0)} сом', style: GoogleFonts.comfortaa(fontSize: 28, color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Введите сумму', style: GoogleFonts.comfortaa()),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _sumInputController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(?!-)[0-9]*\.?[0-9]*'))],
                          style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            filled: true,
                            fillColor: const Color(0xFFF1F1F1),
                            hintText: '0', // запасной вариант
                            suffixText: 'сом',
                            suffixStyle: GoogleFonts.comfortaa(
                              textStyle: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (state.savedCards.isEmpty)
                          Center(
                            child: Text('У вас нет карт', style: GoogleFonts.comfortaa()),
                          )
                        else ...[
                          Text('Недавно использованные карты', style: GoogleFonts.comfortaa()),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: state.savedCards.map((card) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.blue),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset('assets/icons/visa.svg', height: 16),
                                    const SizedBox(height: 10),
                                    Text('*$card', style: GoogleFonts.comfortaa(fontSize: 14)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => _showAddCardDialog(context),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'Добавить карту',
                            style: GoogleFonts.comfortaa(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: BlocBuilder<BankCardPaymentCubit, BankCardPaymentState>(
                      builder: (context, state) {
                        final isActive = state.savedCards.isNotEmpty &&
                            double.tryParse(_sumInputController.text) != null &&
                            double.parse(_sumInputController.text) > 0;
                        return AnimatedScale(
                          scale: state.status == PaymentStatus.error ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: ElevatedButton(
                            onPressed: isActive
                                ? () {
                              final cubit = context.read<BankCardPaymentCubit>();
                              if (state.topUpCount == 0) {
                                cubit.processBalanceTopUp(_sumInputController.text);
                              } else {
                                showCvvConfirmationDialog(
                                  context: context,
                                  onConfirm: (cvv) {
                                    context.read<BankCardPaymentCubit>().processBalanceTopUp(_sumInputController.text);
                                  },
                                );
                              }
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive ? AppColors.blue : AppColors.blueGray,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: isActive ? 4 : 0,
                            ),
                            child: Text(
                              'Пополнить',
                              style: GoogleFonts.comfortaa(
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
