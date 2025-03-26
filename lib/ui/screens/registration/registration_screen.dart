import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _acceptTerms = false;
  String? _usernameError;
  String? _phoneError;
  String? _termsError;

  void _validateAndSubmit() {
    setState(() {
      _usernameError = _usernameController.text.isEmpty ? 'Поле не может быть пустым' : null;
      _phoneError = _phoneController.text.length != 9 ? 'Телефон должен содержать 9 цифр' : null;
      _termsError = !_acceptTerms ? 'Необходимо принять политику конфиденциальности' : null;
    });

    if (_usernameError == null && _phoneError == null && _termsError == null) {
      // Handle code retrieval logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Регистрация',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Простой старт — удобная парковка в один клик!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/first.png', // Assuming the same image as in the onboarding screen
                width: 236,
                height: 182,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  errorText: _usernameError,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telephone Number',
                  hintText: '777 777 777', // Подсказка
                  border: OutlineInputBorder(),
                  prefixText: '+996 | ',
                  prefixStyle: TextStyle(color: Colors.black),
                  errorText: _phoneError,
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9), // Limiting input to 9 digits for phone number
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Я прочитал(а) и принимаю политику конфиденциальности.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (_termsError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _termsError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue, // Винный голубой цвет
                  padding: EdgeInsets.symmetric(vertical: 16), // Размер кнопки
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  minimumSize: Size(double.infinity, 48), // Кнопка на всю ширину
                ),
                child: Text(
                  'Получить код',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}