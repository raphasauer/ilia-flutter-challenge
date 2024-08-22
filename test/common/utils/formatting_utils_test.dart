import 'package:flutter_test/flutter_test.dart';
import 'package:ilia_flutter_challenge/common/utils/formatting_utils.dart';

void main() {
  group('FormatUtils', () {
    test('Should format currency correctly with default settings', () {
      int amount = 1000000;

      String formattedAmount = FormatUtils.formatCurrency(amount);

      expect(formattedAmount, '\$1,000,000');
    });

    test('Should format currency with zero amount', () {
      int amount = 0;

      String formattedAmount = FormatUtils.formatCurrency(amount);

      expect(formattedAmount, '\$0');
    });

    test('should format negative currency amounts correctly', () {
      int amount = -1234567;

      String formattedAmount = FormatUtils.formatCurrency(amount);

      expect(formattedAmount, '-\$1,234,567');
    });

    test('should format large currency amounts correctly', () {
      int amount = 987654321;

      String formattedAmount = FormatUtils.formatCurrency(amount);

      expect(formattedAmount, '\$987,654,321');
    });
  });
}
