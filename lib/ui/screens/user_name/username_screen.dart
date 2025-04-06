import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toktot_app/navigation/routs/routs.dart';
import 'package:toktot_app/theme/app_colors.dart';

class UsernameScreen extends StatefulWidget {
  UsernameScreen({super.key});

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController usernameController = TextEditingController();
  String? errorText;

  void _validateAndProceed() {
    setState(() {
      if (usernameController.text.isEmpty) {
        errorText = 'Заполните поле.';
      } else {
        errorText = null;
        Navigator.pushNamed(context, Routs.consent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 124),
            Text(
              'Введите ваше имя',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 35),
            SvgPicture.asset(
              'assets/images/placeholder.svg',
              width: 309,
              height: 262,
            ),
            const SizedBox(height: 35),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: 'Ваше имя',
                filled: true,
                fillColor: const Color(0xFFF1F1F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: errorText != null ? Colors.red : Colors.transparent,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: errorText != null ? Colors.red : Colors.transparent,
                    width: 1,
                  ),
                ),
                errorText: errorText,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: usernameController.text.isNotEmpty
                  ? _validateAndProceed
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: usernameController.text.isNotEmpty
                    ? AppColors.bluePrimary
                    : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                'Далее',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
