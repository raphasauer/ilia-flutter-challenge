import 'package:intl/intl.dart';

class FormatUtils {
  static String formatCurrency(int amount) {
    final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatCurrency.format(amount);
  }
}
