import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'consent_cubit.dart';

/// Screen for user consent.
class ConsentScreen extends StatelessWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsentCubit(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Подтверждение данных', // Title of the app bar
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/images/third.png', // Ensure this file exists
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  'Подтвердите, что вы согласны отдать свои данные, чтобы продолжить.', // Instruction text
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                BlocBuilder<ConsentCubit, bool>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text('Готовы ли вы подтвердить ваши данные?'), // Checkbox label
                          value: state,
                          onChanged: (value) {
                            context
                                .read<ConsentCubit>()
                                .toggleConsent(value ?? false); // Toggle consent state
                          },
                        ),
                        if (state)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registration'); // Navigate to registration screen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              minimumSize: Size(double.infinity, 48),
                            ),
                            child: Text(
                              'Далее',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}