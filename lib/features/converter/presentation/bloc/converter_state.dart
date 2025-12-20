part of 'converter_bloc.dart';

enum ConverterStatus { idle, loading, content, error }

class ConverterState {
  const ConverterState({
    this.status = ConverterStatus.idle,
    this.from = 'USD',
    this.to = 'EUR',
    this.amountText = '1',
    this.amountErrorText,
    this.swapCount = 0,
    this.conversion,
    this.errorMessage,
  });

  final ConverterStatus status;
  final String from;
  final String to;
  final String amountText;
  final String? amountErrorText;
  final int swapCount;
  final Conversion? conversion;
  final String? errorMessage;

  ConverterState copyWith({
    ConverterStatus? status,
    String? from,
    String? to,
    String? amountText,
    String? amountErrorText,
    int? swapCount,
    Conversion? conversion,
    String? errorMessage,
  }) {
    return ConverterState(
      status: status ?? this.status,
      from: from ?? this.from,
      to: to ?? this.to,
      amountText: amountText ?? this.amountText,
      amountErrorText: amountErrorText ?? this.amountErrorText,
      swapCount: swapCount ?? this.swapCount,
      conversion: conversion ?? this.conversion,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
