import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/core/result/result.dart';
import 'package:currency_converter/features/converter/domain/entities/conversion.dart';
import 'package:currency_converter/features/converter/domain/usecases/convert_currency.dart';
import 'package:currency_converter/features/rates/domain/entities/latest_rate_quote.dart';
import 'package:currency_converter/features/rates/domain/repositories/rates_repository.dart';

class _MockRatesRepository extends Mock implements RatesRepository {}

void main() {
  test('ConvertCurrency multiplies amount by latest rate', () async {
    final repo = _MockRatesRepository();
    final uc = ConvertCurrency(repo);

    when(
      () => repo.getLatestRate(
        from: any(named: 'from'),
        to: any(named: 'to'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => Success(
        LatestRateQuote(
          from: 'USD',
          to: 'EUR',
          rate: 2.0,
          fetchedAtUtc: DateTime.utc(2025, 1, 1),
        ),
      ),
    );

    final res = await uc(from: 'USD', to: 'EUR', amount: 3);
    expect(res.isSuccess, true);
    final conversion = (res as Success<Conversion>).data;
    expect(conversion.convertedAmount, 6.0);
  });
}
