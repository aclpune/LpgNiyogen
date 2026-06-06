import 'package:intl/intl.dart';

/// ─────────────────────────────────────────────
/// FORMAT UTILITIES
/// ─────────────────────────────────────────────
abstract final class AppFormat {

  static final _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final _inrCompact = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 1,
  );

  static final _count = NumberFormat('#,##,###', 'en_IN');

  /// Full currency: ₹11,86,437.00
  static String currency(double value) => _inr.format(value);

  /// Compact: ₹11.8L  (for hero chips)
  static String currencyCompact(double value) => _inrCompact.format(value);

  /// Integer count with Indian grouping: 1,210
  static String count(int value) => _count.format(value);

  /// Percentage: 82.5%
  static String percent(double value) =>
      '${value.toStringAsFixed(1)}%';

  /// Date: Thursday, 24 April 2026
  static String heroDate(DateTime dt) =>
      DateFormat('EEEE, d MMMM yyyy').format(dt);

  /// Short date: 24 Apr
  static String shortDate(DateTime dt) =>
      DateFormat('d MMM').format(dt);
}
