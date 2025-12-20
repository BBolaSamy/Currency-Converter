part of 'converter_bloc.dart';

sealed class ConverterEvent {
  const ConverterEvent();
}

final class ConverterStarted extends ConverterEvent {
  const ConverterStarted();
}

final class ConverterFromChanged extends ConverterEvent {
  const ConverterFromChanged(this.from);
  final String from;
}

final class ConverterToChanged extends ConverterEvent {
  const ConverterToChanged(this.to);
  final String to;
}

final class ConverterSwapPressed extends ConverterEvent {
  const ConverterSwapPressed();
}

final class ConverterAmountChanged extends ConverterEvent {
  const ConverterAmountChanged(this.amountText);
  final String amountText;
}

final class ConverterRefreshPressed extends ConverterEvent {
  const ConverterRefreshPressed();
}
