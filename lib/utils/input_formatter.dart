import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneMaskFormatter = MaskTextInputFormatter(
  mask: '(###) ##-##-##',
  filter: { "#": RegExp(r'\d') },
);

final cardNumberFormatter = MaskTextInputFormatter(
  mask: '#### #### #### ####',
  filter: {"#": RegExp(r'[0-9]')},
);

final expiryDateFormatter = MaskTextInputFormatter(
  mask: '##/##',
  filter: {"#": RegExp(r'[0-9]')},
);

final cvvFormatter = MaskTextInputFormatter(
  mask: '###',
  filter: {"#": RegExp(r'[0-9]')},
);