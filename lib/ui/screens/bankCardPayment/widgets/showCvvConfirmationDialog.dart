import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCvvConfirmationDialog({
  required BuildContext context,
  required void Function(String cvv) onConfirm,
}) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Введите CVV'),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 3,
              decoration: InputDecoration(hintText: '123'),
              validator: (v) => v != null && v.length == 3 ? null : 'Введите CVV',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  onConfirm(controller.text);
                }
              },
              child: Text('Подтвердить'),
            )
          ],
        ),
      ),
    ),
  );
}