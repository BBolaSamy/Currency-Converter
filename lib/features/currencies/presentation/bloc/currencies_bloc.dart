import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/currency.dart';
import '../../domain/usecases/refresh_currencies_if_stale.dart';
import '../../domain/usecases/set_currency_favorite.dart';
import '../../domain/usecases/watch_currencies.dart';

part 'currencies_event.dart';
part 'currencies_state.dart';

@injectable
class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  CurrenciesBloc(
    this._watch,
    this._refreshIfStale,
    this._setFavorite,
  ) : super(const CurrenciesState()) {
    on<CurrenciesStarted>(_onStarted);
    on<CurrenciesSearchChanged>(_onSearchChanged);
    on<CurrenciesFavoritesFilterChanged>(_onFavoritesFilterChanged);
    on<CurrenciesFavoriteToggled>(_onFavoriteToggled);
    on<CurrenciesRetryPressed>(_onRetry);
    on<_CurrenciesItemsUpdated>(_onItemsUpdated);
  }

  final WatchCurrencies _watch;
  final RefreshCurrenciesIfStale _refreshIfStale;
  final SetCurrencyFavorite _setFavorite;

  StreamSubscription<List<CurrencyItem>>? _sub;

  Future<void> _onStarted(
    CurrenciesStarted event,
    Emitter<CurrenciesState> emit,
  ) async {
    emit(state.copyWith(status: CurrenciesStatus.loading, errorMessage: null));

    await _sub?.cancel();
    _sub = _watch().listen((items) {
      add(_CurrenciesItemsUpdated(items));
    });

    // immediate stale-check refresh in background
    final res = await _refreshIfStale();
    if (res is FailureResult<void>) {
      emit(state.copyWith(
        status: CurrenciesStatus.error,
        errorMessage: res.failure.message,
      ));
      return;
    }
  }

  void _onSearchChanged(
    CurrenciesSearchChanged event,
    Emitter<CurrenciesState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  void _onFavoritesFilterChanged(
    CurrenciesFavoritesFilterChanged event,
    Emitter<CurrenciesState> emit,
  ) {
    emit(state.copyWith(showFavoritesOnly: event.showFavoritesOnly));
  }

  Future<void> _onFavoriteToggled(
    CurrenciesFavoriteToggled event,
    Emitter<CurrenciesState> emit,
  ) async {
    await _setFavorite(
      currencyCode: event.currencyCode,
      isFavorite: event.isFavorite,
    );
  }

  Future<void> _onRetry(
    CurrenciesRetryPressed event,
    Emitter<CurrenciesState> emit,
  ) async {
    final res = await _refreshIfStale();
    if (res is FailureResult<void>) {
      emit(state.copyWith(
        status: CurrenciesStatus.error,
        errorMessage: res.failure.message,
      ));
    }
  }

  void _onItemsUpdated(
    _CurrenciesItemsUpdated event,
    Emitter<CurrenciesState> emit,
  ) {
    // If we were loading, switch to content once we have anything (including empty list).
    final status = state.status == CurrenciesStatus.loading
        ? CurrenciesStatus.content
        : state.status;
    emit(state.copyWith(status: status, items: event.items));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}


