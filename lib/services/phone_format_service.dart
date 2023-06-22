import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 12) {
      return oldValue;
    }
    String formatted = '';
    int index = 0;
    for (int i = 0; i < newValue.text.length; i++) {
      if (index == 3 || index == 7) {
        formatted += '-';
        index++;
      }
      if (index >= 12) {
        break;
      }
      formatted += newValue.text[i];
      index++;
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

