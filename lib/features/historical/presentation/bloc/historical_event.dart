part of 'historical_bloc.dart';

sealed class HistoricalEvent {
  const HistoricalEvent();
}

final class HistoricalStarted extends HistoricalEvent {
  const HistoricalStarted();
}

final class HistoricalFromChanged extends HistoricalEvent {
  const HistoricalFromChanged(this.from);
  final String from;
}

final class HistoricalToChanged extends HistoricalEvent {
  const HistoricalToChanged(this.to);
  final String to;
}

final class HistoricalSwapPressed extends HistoricalEvent {
  const HistoricalSwapPressed();
}

final class HistoricalRefreshPressed extends HistoricalEvent {
  const HistoricalRefreshPressed();
}
