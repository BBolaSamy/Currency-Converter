import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../rates/domain/entities/latest_rate_quote.dart';
import '../../../rates/domain/repositories/rates_repository.dart';
import '../entities/conversion.dart';

@injectable
class ConvertCurrency {
  const ConvertCurrency(this._rates);

  final RatesRepository _rates;

  Future<Result<Conversion>> call({
    required String from,
    required String to,
    required double amount,
    bool forceRefreshRate = false,
  }) async {
    final res = await _rates.getLatestRate(
      from: from,
      to: to,
      forceRefresh: forceRefreshRate,
    );

    return res.when(
      success: (LatestRateQuote quote) {
        return Success(
          Conversion(
            amount: amount,
            convertedAmount: amount * quote.rate,
            quote: quote,
          ),
        );
      },
      failure: (f) => FailureResult(f),
    );
  }
}
