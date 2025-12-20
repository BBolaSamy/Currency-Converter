import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../../currencies/domain/usecases/refresh_currencies_if_stale.dart';
import '../../../rates/domain/entities/rate_point.dart';
import '../../../rates/domain/usecases/get_last_7_days.dart';

part 'historical_event.dart';
part 'historical_state.dart';

@injectable
class HistoricalBloc extends Bloc<HistoricalEvent, HistoricalState> {
  HistoricalBloc(this._getLast7Days, this._refreshCurrencies)
    : super(const HistoricalState()) {
    on<HistoricalStarted>(_onStarted);
    on<HistoricalFromChanged>(_onFromChanged);
    on<HistoricalToChanged>(_onToChanged);
    on<HistoricalSwapPressed>(_onSwap);
    on<HistoricalRefreshPressed>(_onRefresh);
  }

  final GetLast7Days _getLast7Days;
  final RefreshCurrenciesIfStale _refreshCurrencies;

  Future<void> _onStarted(
    HistoricalStarted event,
    Emitter<HistoricalState> emit,
  ) async {
    await _refreshCurrencies();
    await _load(emit, forceRefresh: false);
  }

  Future<void> _onFromChanged(
    HistoricalFromChanged event,
    Emitter<HistoricalState> emit,
  ) async {
    emit(state.copyWith(from: event.from));
    await _load(emit, forceRefresh: false);
  }

  Future<void> _onToChanged(
    HistoricalToChanged event,
    Emitter<HistoricalState> emit,
  ) async {
    emit(state.copyWith(to: event.to));
    await _load(emit, forceRefresh: false);
  }

  Future<void> _onSwap(
    HistoricalSwapPressed event,
    Emitter<HistoricalState> emit,
  ) async {
    emit(state.copyWith(from: state.to, to: state.from));
    await _load(emit, forceRefresh: false);
  }

  Future<void> _onRefresh(
    HistoricalRefreshPressed event,
    Emitter<HistoricalState> emit,
  ) async {
    await _load(emit, forceRefresh: true);
  }

  Future<void> _load(
    Emitter<HistoricalState> emit, {
    required bool forceRefresh,
  }) async {
    emit(state.copyWith(status: HistoricalStatus.loading, errorMessage: null));

    final res = await _getLast7Days(
      from: state.from,
      to: state.to,
      forceRefresh: forceRefresh,
    );

    if (res is FailureResult<List<RatePoint>>) {
      emit(
        state.copyWith(
          status: HistoricalStatus.error,
          points: const [],
          errorMessage: res.failure.message,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: HistoricalStatus.content,
        points: (res as Success<List<RatePoint>>).data,
        errorMessage: null,
      ),
    );
  }
}
