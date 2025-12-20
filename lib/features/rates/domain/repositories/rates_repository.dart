import '../../../../core/result/result.dart';
import '../entities/latest_rate_quote.dart';
import '../entities/rate_point.dart';

abstract class RatesRepository {
  Future<Result<LatestRateQuote>> getLatestRate({
    required String from,
    required String to,
    bool forceRefresh = false,
  });

  Future<Result<List<RatePoint>>> getLast7Days({
    required String from,
    required String to,
    bool forceRefresh = false,
  });
}
