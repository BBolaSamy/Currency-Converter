import 'package:flutter/services.dart';

/// Allows only numbers with an optional decimal separator (.) and up to [decimalRange] decimals.
///
/// - Allows intermediate states like `""`, `"."`, `"12."` while typing.
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
    : assert(decimalRange >= 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (text == '.') {
      return newValue.copyWith(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    // Only digits and at most one dot.
    final dotCount = '.'.allMatches(text).length;
    if (dotCount > 1) return oldValue;
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) return oldValue;

    if (decimalRange == 0 && text.contains('.')) return oldValue;

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length == 2 && parts[1].length > decimalRange) return oldValue;
    }
    return newValue;
  }
}
