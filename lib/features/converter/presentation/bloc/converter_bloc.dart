import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/conversion.dart';
import '../../domain/usecases/convert_currency.dart';
import '../../../currencies/domain/usecases/refresh_currencies_if_stale.dart';

part 'converter_event.dart';
part 'converter_state.dart';

@injectable
class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  ConverterBloc(this._convert, this._refreshCurrencies)
    : super(const ConverterState()) {
    on<ConverterStarted>(_onStarted);
    on<ConverterFromChanged>(_onFromChanged);
    on<ConverterToChanged>(_onToChanged);
    on<ConverterSwapPressed>(_onSwap);
    on<ConverterAmountChanged>(_onAmountChanged);
    on<ConverterRefreshPressed>(_onRefresh);
  }

  final ConvertCurrency _convert;
  final RefreshCurrenciesIfStale _refreshCurrencies;

  Future<void> _onStarted(
    ConverterStarted event,
    Emitter<ConverterState> emit,
  ) async {
    // ensure currency catalog is present (offline-first: no failure if offline)
    await _refreshCurrencies();
    await _recompute(emit, forceRateRefresh: false);
  }

  Future<void> _onFromChanged(
    ConverterFromChanged event,
    Emitter<ConverterState> emit,
  ) async {
    emit(state.copyWith(from: event.from));
    await _recompute(emit, forceRateRefresh: false);
  }

  Future<void> _onToChanged(
    ConverterToChanged event,
    Emitter<ConverterState> emit,
  ) async {
    emit(state.copyWith(to: event.to));
    await _recompute(emit, forceRateRefresh: false);
  }

  Future<void> _onSwap(
    ConverterSwapPressed event,
    Emitter<ConverterState> emit,
  ) async {
    emit(
      state.copyWith(
        from: state.to,
        to: state.from,
        swapCount: state.swapCount + 1,
      ),
    );
    await _recompute(emit, forceRateRefresh: false);
  }

  Future<void> _onAmountChanged(
    ConverterAmountChanged event,
    Emitter<ConverterState> emit,
  ) async {
    emit(state.copyWith(amountText: event.amountText));
    await _recompute(emit, forceRateRefresh: false);
  }

  Future<void> _onRefresh(
    ConverterRefreshPressed event,
    Emitter<ConverterState> emit,
  ) async {
    await _recompute(emit, forceRateRefresh: true);
  }

  Future<void> _recompute(
    Emitter<ConverterState> emit, {
    required bool forceRateRefresh,
  }) async {
    final raw = state.amountText.trim();
    if (raw.isEmpty) {
      emit(
        state.copyWith(
          status: ConverterStatus.idle,
          conversion: null,
          errorMessage: null,
          amountErrorText: null,
        ),
      );
      return;
    }

    final amount = double.tryParse(raw);
    if (amount == null) {
      emit(
        state.copyWith(
          status: ConverterStatus.idle,
          conversion: null,
          errorMessage: null,
          amountErrorText: 'Enter a valid number',
        ),
      );
      return;
    }

    if (amount <= 0) {
      emit(
        state.copyWith(
          status: ConverterStatus.idle,
          conversion: null,
          errorMessage: null,
          amountErrorText: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ConverterStatus.loading,
        errorMessage: null,
        amountErrorText: null,
      ),
    );
    final res = await _convert(
      from: state.from,
      to: state.to,
      amount: amount,
      forceRefreshRate: forceRateRefresh,
    );

    if (res is FailureResult<Conversion>) {
      emit(
        state.copyWith(
          status: ConverterStatus.error,
          conversion: null,
          errorMessage: res.failure.message,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ConverterStatus.content,
        conversion: (res as Success<Conversion>).data,
        errorMessage: null,
        amountErrorText: null,
      ),
    );
  }
}
