import 'package:flutter/services.dart';

/// Utilities for validating and formatting APOD date inputs.
class DateValidator {
  static final DateTime _apodStartDate = DateTime(1995, 6, 16);

  /// Checks if a date string matches the YYYY-MM-DD pattern.
  static bool isValidFormat(String input) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regex.hasMatch(input);
  }

  /// Parses date and returns a validation error message if invalid, or null if valid.
  static String? getValidationError(String input) {
    if (input.isEmpty) {
      return 'Please enter a date';
    }

    if (!isValidFormat(input)) {
      return 'Format must be YYYY-MM-DD';
    }

    final parts = input.split('-');
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      return 'Invalid date elements';
    }

    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    // Simple day count check (handles basic leap years)
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (day < 1 || day > daysInMonth) {
      return 'Day must be between 01 and $daysInMonth';
    }

    final parsedDate = DateTime.tryParse(input);
    if (parsedDate == null) {
      return 'Invalid calendar date';
    }

    // Compare date bounds
    // Normalize to date-only comparisons (midnight)
    final normalizedStart = DateTime(_apodStartDate.year, _apodStartDate.month, _apodStartDate.day);
    final normalizedParsed = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    
    final now = DateTime.now();
    final normalizedToday = DateTime(now.year, now.month, now.day);

    if (normalizedParsed.isBefore(normalizedStart)) {
      return 'APOD started on June 16, 1995';
    }

    if (normalizedParsed.isAfter(normalizedToday)) {
      return 'Date cannot be in the future';
    }

    return null;
  }
}

/// A text input formatter that automatically adds hyphens to format input as YYYY-MM-DD.
class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Handle backspaces/deletes gracefully without enforcing formatting immediately
    if (text.length < oldValue.text.length) {
      return newValue;
    }

    final digits = text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    if (digits.length > 8) {
      return oldValue;
    }

    for (var i = 0; i < digits.length; i++) {
      if (i == 4 || i == 6) {
        buffer.write('-');
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
