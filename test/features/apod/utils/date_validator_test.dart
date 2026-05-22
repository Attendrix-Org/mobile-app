import 'package:attendrix_app/features/apod/utils/date_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateValidator Tests', () {
    test('isValidFormat checks YYYY-MM-DD pattern correctly', () {
      expect(DateValidator.isValidFormat('2026-05-22'), isTrue);
      expect(DateValidator.isValidFormat('95-06-16'), isFalse);
      expect(DateValidator.isValidFormat('2026/05/22'), isFalse);
      expect(DateValidator.isValidFormat('2026-5-22'), isFalse);
      expect(DateValidator.isValidFormat('2026-05-2'), isFalse);
      expect(DateValidator.isValidFormat('abc-de-fg'), isFalse);
    });

    test('getValidationError returns correct message for empty input', () {
      expect(
        DateValidator.getValidationError(''),
        equals('Please enter a date'),
      );
    });

    test('getValidationError returns correct message for incorrect format', () {
      expect(
        DateValidator.getValidationError('2026/05/22'),
        equals('Format must be YYYY-MM-DD'),
      );
    });

    test(
      'getValidationError returns correct message for invalid months/days',
      () {
        expect(
          DateValidator.getValidationError('2026-13-10'),
          equals('Month must be between 01 and 12'),
        );
        expect(
          DateValidator.getValidationError('2026-00-10'),
          equals('Month must be between 01 and 12'),
        );
        expect(
          DateValidator.getValidationError('2026-02-30'),
          equals('Day must be between 01 and 28'),
        );
        expect(
          DateValidator.getValidationError('2024-02-30'), // Leap year
          equals('Day must be between 01 and 29'),
        );
      },
    );

    test(
      'getValidationError returns correct message for dates before June 16, 1995',
      () {
        expect(
          DateValidator.getValidationError('1995-06-15'),
          equals('APOD started on June 16, 1995'),
        );
        expect(
          DateValidator.getValidationError('1990-01-01'),
          equals('APOD started on June 16, 1995'),
        );
      },
    );

    test('getValidationError returns correct message for future dates', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowStr =
          '${tomorrow.year}-'
          '${tomorrow.month.toString().padLeft(2, '0')}-'
          '${tomorrow.day.toString().padLeft(2, '0')}';
      expect(
        DateValidator.getValidationError(tomorrowStr),
        equals('Date cannot be in the future'),
      );
    });

    test('getValidationError returns null for valid calendar dates', () {
      expect(DateValidator.getValidationError('1995-06-16'), isNull);
      expect(DateValidator.getValidationError('2000-01-01'), isNull);

      final today = DateTime.now();
      final todayStr =
          '${today.year}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';
      expect(DateValidator.getValidationError(todayStr), isNull);
    });
  });

  group('DateTextInputFormatter Tests', () {
    final formatter = DateTextInputFormatter();

    test('adds hyphens as digits are typed', () {
      const oldValue = TextEditingValue.empty;

      // Type "2026"
      var val = formatter.formatEditUpdate(
        oldValue,
        const TextEditingValue(text: '2026'),
      );
      expect(val.text, equals('2026'));

      // Type "20260" -> should add hyphen: "2026-0"
      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '20260'),
      );
      expect(val.text, equals('2026-0'));

      // Type "2026-05"
      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '2026-05'),
      );
      expect(val.text, equals('2026-05'));

      // Type "2026-052" -> should add hyphen: "2026-05-2"
      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '2026-052'),
      );
      expect(val.text, equals('2026-05-2'));

      // Type "2026-05-22"
      val = formatter.formatEditUpdate(
        val,
        const TextEditingValue(text: '2026-05-22'),
      );
      expect(val.text, equals('2026-05-22'));
    });

    test('gracefully handles deletes/backspaces', () {
      const oldValue = TextEditingValue(
        text: '2026-0',
        selection: TextSelection.collapsed(offset: 6),
      );

      // User presses backspace to delete '0' -> text becomes "2026-"
      final val = formatter.formatEditUpdate(
        oldValue,
        const TextEditingValue(text: '2026-'),
      );
      expect(val.text, equals('2026-'));
    });

    test('blocks inputs longer than 8 digits', () {
      const oldValue = TextEditingValue(
        text: '2026-05-22',
        selection: TextSelection.collapsed(offset: 10),
      );

      // Try typing an extra digit "2" at the end -> "2026-05-222"
      final val = formatter.formatEditUpdate(
        oldValue,
        const TextEditingValue(text: '2026-05-222'),
      );
      expect(val.text, equals('2026-05-22'));
    });
  });
}
