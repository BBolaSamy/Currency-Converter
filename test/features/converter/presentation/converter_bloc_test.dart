import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:currency_converter/core/result/result.dart';
import 'package:currency_converter/features/converter/domain/entities/conversion.dart';
import 'package:currency_converter/features/converter/domain/usecases/convert_currency.dart';
import 'package:currency_converter/features/converter/presentation/bloc/converter_bloc.dart';
import 'package:currency_converter/features/currencies/domain/usecases/refresh_currencies_if_stale.dart';
import 'package:currency_converter/features/rates/domain/entities/latest_rate_quote.dart';

class _MockConvertCurrency extends Mock implements ConvertCurrency {}

class _MockRefreshCurrencies extends Mock implements RefreshCurrenciesIfStale {}

void main() {
  blocTest<ConverterBloc, ConverterState>(
    'emits loading->content on started when conversion succeeds',
    build: () {
      final convert = _MockConvertCurrency();
      final refresh = _MockRefreshCurrencies();

      when(() => refresh()).thenAnswer((_) async => const Success(null));
      when(
        () => convert(
          from: any(named: 'from'),
          to: any(named: 'to'),
          amount: any(named: 'amount'),
          forceRefreshRate: any(named: 'forceRefreshRate'),
        ),
      ).thenAnswer(
        (_) async => Success(
          Conversion(
            amount: 1,
            convertedAmount: 1.5,
            quote: LatestRateQuote(
              from: 'USD',
              to: 'EUR',
              rate: 1.5,
              fetchedAtUtc: DateTime.utc(2025, 1, 1),
            ),
          ),
        ),
      );

      return ConverterBloc(convert, refresh);
    },
    act: (bloc) => bloc.add(const ConverterStarted()),
    expect: () => [
      isA<ConverterState>().having(
        (s) => s.status,
        'status',
        ConverterStatus.loading,
      ),
      isA<ConverterState>()
          .having((s) => s.status, 'status', ConverterStatus.content)
          .having((s) => s.conversion?.convertedAmount, 'converted', 1.5),
    ],
  );
}
