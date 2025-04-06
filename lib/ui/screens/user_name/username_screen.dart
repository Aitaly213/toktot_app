import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/navigation/routs/routs.dart';
import 'package:toktot_app/theme/app_colors.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController usernameController = TextEditingController();
  String? errorText;

  void _validateAndProceed() {
    setState(() {
      if (usernameController.text.trim().isEmpty) {
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
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Введите ваше имя',
                  style: GoogleFonts.comfortaa(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                    hintStyle: GoogleFonts.comfortaa(),
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
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: errorText != null ? Colors.red : AppColors.bluePrimary,
                      ),
                    ),
                    errorText: errorText,
                  ),
                  style: GoogleFonts.comfortaa(),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _validateAndProceed(),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: usernameController.text.trim().isNotEmpty
                      ? _validateAndProceed
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: usernameController.text.trim().isNotEmpty
                        ? AppColors.bluePrimary
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: GoogleFonts.comfortaa(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    'Далее',
                    style: GoogleFonts.comfortaa(
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}