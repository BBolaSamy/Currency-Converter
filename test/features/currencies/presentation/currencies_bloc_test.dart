import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:currency_converter/core/result/result.dart';
import 'package:currency_converter/core/domain/entities/currency_entity.dart';
import 'package:currency_converter/features/currencies/domain/entities/currency.dart';
import 'package:currency_converter/features/currencies/domain/usecases/refresh_currencies_if_stale.dart';
import 'package:currency_converter/features/currencies/domain/usecases/set_currency_favorite.dart';
import 'package:currency_converter/features/currencies/domain/usecases/watch_currencies.dart';
import 'package:currency_converter/features/currencies/presentation/bloc/currencies_bloc.dart';

class _MockWatchCurrencies extends Mock implements WatchCurrencies {}

class _MockRefreshCurrencies extends Mock implements RefreshCurrenciesIfStale {}

class _MockSetFavorite extends Mock implements SetCurrencyFavorite {}

void main() {
  blocTest<CurrenciesBloc, CurrenciesState>(
    'emits loading->content when stream emits items',
    build: () {
      final watch = _MockWatchCurrencies();
      final refresh = _MockRefreshCurrencies();
      final setFav = _MockSetFavorite();

      when(() => watch()).thenAnswer(
        (_) => Stream<List<CurrencyItem>>.fromIterable([
          [
            CurrencyItem(
              currency: CurrencyEntity(code: 'USD', name: 'US Dollar'),
              isFavorite: false,
            ),
          ],
        ]),
      );
      when(() => refresh()).thenAnswer((_) async => const Success(null));
      when(
        () => setFav(
          currencyCode: any(named: 'currencyCode'),
          isFavorite: any(named: 'isFavorite'),
        ),
      ).thenAnswer((_) async => const Success(null));

      final bloc = CurrenciesBloc(watch, refresh, setFav);
      return bloc;
    },
    act: (bloc) => bloc.add(const CurrenciesStarted()),
    expect: () => [
      isA<CurrenciesState>().having(
        (s) => s.status,
        'status',
        CurrenciesStatus.loading,
      ),
      isA<CurrenciesState>()
          .having((s) => s.status, 'status', CurrenciesStatus.content)
          .having((s) => s.items.length, 'items', 1),
    ],
  );
}
