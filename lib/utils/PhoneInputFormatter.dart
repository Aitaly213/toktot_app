import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneMaskFormatter = MaskTextInputFormatter(
  mask: '(###) ##-##-##',
  filter: { "#": RegExp(r'\d') },
);