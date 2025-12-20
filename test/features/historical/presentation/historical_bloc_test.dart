import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:currency_converter/core/result/result.dart';
import 'package:currency_converter/features/currencies/domain/usecases/refresh_currencies_if_stale.dart';
import 'package:currency_converter/features/historical/presentation/bloc/historical_bloc.dart';
import 'package:currency_converter/features/rates/domain/entities/rate_point.dart';
import 'package:currency_converter/features/rates/domain/usecases/get_last_7_days.dart';

class _MockGetLast7Days extends Mock implements GetLast7Days {}

class _MockRefreshCurrencies extends Mock implements RefreshCurrenciesIfStale {}

void main() {
  blocTest<HistoricalBloc, HistoricalState>(
    'emits loading->content on started when points load',
    build: () {
      final getLast7 = _MockGetLast7Days();
      final refresh = _MockRefreshCurrencies();

      when(() => refresh()).thenAnswer((_) async => const Success(null));
      when(
        () => getLast7(
          from: any(named: 'from'),
          to: any(named: 'to'),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer(
        (_) async => const Success([
          RatePoint(date: '2025-01-01', rate: 1.0),
          RatePoint(date: '2025-01-02', rate: 1.1),
        ]),
      );

      return HistoricalBloc(getLast7, refresh);
    },
    act: (bloc) => bloc.add(const HistoricalStarted()),
    expect: () => [
      isA<HistoricalState>().having(
        (s) => s.status,
        'status',
        HistoricalStatus.loading,
      ),
      isA<HistoricalState>()
          .having((s) => s.status, 'status', HistoricalStatus.content)
          .having((s) => s.points.length, 'points', 2),
    ],
  );
}
