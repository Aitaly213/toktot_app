import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../themes/app_colors.dart';

class BankCardPaymentScreen extends StatefulWidget {
  const BankCardPaymentScreen({super.key});

  @override
  State<BankCardPaymentScreen> createState() => _BankCardPaymentScreenState();
}

class _BankCardPaymentScreenState extends State<BankCardPaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sumInputController = TextEditingController();

  List<String> savedCards = [];

  void _processPayment() {
    final isValid = _cardNumberController.text.length >= 16 &&
        _expiryDateController.text.isNotEmpty &&
        _cvvController.text.length >= 3 &&
        _amountController.text.isNotEmpty;

    if (!isValid) {
      _showDialog(success: false, message: 'Проверьте введенные данные');
      return;
    }

    final random = Random();
    final isAccepted = random.nextBool();

    if (isAccepted) {
      setState(() {
        savedCards.add(_cardNumberController.text.substring(_cardNumberController.text.length - 4));
      });
      _showDialog(success: true, message: 'Карта успешно добавлена');
    } else {
      _showDialog(success: false, message: 'Карта не принята, попробуйте другую');
    }
  }

  void _showDialog({required bool success, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'Успех' : 'Ошибка',
            style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold)),
        content: Text(
          message,
          style: GoogleFonts.comfortaa(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ок', style: GoogleFonts.comfortaa()),
          )
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
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
                children: [
                  Text('Добавить карту', style: GoogleFonts.comfortaa(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Номер карты',
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'Срок',
                            filled: true,
                            fillColor: const Color(0xFFF1F1F1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            filled: true,
                            fillColor: const Color(0xFFF1F1F1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Сумма пополнения',
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _processPayment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text('Сохранить карту', style: GoogleFonts.comfortaa(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    _sumInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Close keyboard on outside tap
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
                  Text('0 сом', style: GoogleFonts.comfortaa(fontSize: 28, color: Colors.white)),
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
                    style: GoogleFonts.comfortaa(fontSize: 20, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      hintText: '345',
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
                  const SizedBox(height: 24),
                  if (savedCards.isEmpty)
                    Center(
                      child: Text('У вас нет карт', style: GoogleFonts.comfortaa()),
                    )
                  else ...[
                    Text('Недавно использованные карты', style: GoogleFonts.comfortaa()),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: savedCards.map((card) => Chip(label: Text('VISA $card'))).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _showAddCardDialog,
                      icon: const Icon(Icons.add),
                      label: Text('Добавить карту', style: GoogleFonts.comfortaa()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (_sumInputController.text.isEmpty) {
                    _showDialog(success: false, message: 'Введите сумму');
                  } else {
                    _showDialog(success: true, message: 'Сумма успешно зачислена');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueGray,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Пополнить',
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}