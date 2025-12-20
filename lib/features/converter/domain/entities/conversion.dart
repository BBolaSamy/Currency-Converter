import '../../../rates/domain/entities/latest_rate_quote.dart';

class Conversion {
  const Conversion({
    required this.amount,
    required this.convertedAmount,
    required this.quote,
  });

  final double amount;
  final double convertedAmount;
  final LatestRateQuote quote;
}
