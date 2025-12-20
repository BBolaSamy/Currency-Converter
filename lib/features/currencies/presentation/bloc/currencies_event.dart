part of 'currencies_bloc.dart';

sealed class CurrenciesEvent {
  const CurrenciesEvent();
}

final class CurrenciesStarted extends CurrenciesEvent {
  const CurrenciesStarted();
}

final class CurrenciesSearchChanged extends CurrenciesEvent {
  const CurrenciesSearchChanged(this.query);
  final String query;
}

final class CurrenciesFavoritesFilterChanged extends CurrenciesEvent {
  const CurrenciesFavoritesFilterChanged(this.showFavoritesOnly);
  final bool showFavoritesOnly;
}

final class CurrenciesFavoriteToggled extends CurrenciesEvent {
  const CurrenciesFavoriteToggled({
    required this.currencyCode,
    required this.isFavorite,
  });

  final String currencyCode;
  final bool isFavorite;
}

final class CurrenciesRetryPressed extends CurrenciesEvent {
  const CurrenciesRetryPressed();
}

final class _CurrenciesItemsUpdated extends CurrenciesEvent {
  const _CurrenciesItemsUpdated(this.items);
  final List<CurrencyItem> items;
}
