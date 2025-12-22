part of 'historical_bloc.dart';

enum HistoricalStatus { loading, content, error }

class HistoricalState {
  const HistoricalState({
    this.status = HistoricalStatus.loading,
    this.from = 'USD',
    this.to = 'KWD',
    this.points = const [],
    this.errorMessage,
  });

  final HistoricalStatus status;
  final String from;
  final String to;
  final List<RatePoint> points;
  final String? errorMessage;

  HistoricalState copyWith({
    HistoricalStatus? status,
    String? from,
    String? to,
    List<RatePoint>? points,
    String? errorMessage,
  }) {
    return HistoricalState(
      status: status ?? this.status,
      from: from ?? this.from,
      to: to ?? this.to,
      points: points ?? this.points,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
