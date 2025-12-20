part of 'currencies_bloc.dart';

enum CurrenciesStatus { initial, loading, content, error }

class CurrenciesState {
  const CurrenciesState({
    this.status = CurrenciesStatus.initial,
    this.items = const [],
    this.query = '',
    this.showFavoritesOnly = false,
    this.errorMessage,
  });

  final CurrenciesStatus status;
  final List<CurrencyItem> items;
  final String query;
  final bool showFavoritesOnly;
  final String? errorMessage;

  List<CurrencyItem> get filteredItems {
    final q = query.trim().toLowerCase();
    Iterable<CurrencyItem> out = items;
    if (showFavoritesOnly) out = out.where((e) => e.isFavorite);
    if (q.isNotEmpty) {
      out = out.where((e) {
        final code = e.currency.code.toLowerCase();
        final name = e.currency.name.toLowerCase();
        return code.contains(q) || name.contains(q);
      });
    }
    return out.toList(growable: false);
  }

  CurrenciesState copyWith({
    CurrenciesStatus? status,
    List<CurrencyItem>? items,
    String? query,
    bool? showFavoritesOnly,
    String? errorMessage,
  }) {
    return CurrenciesState(
      status: status ?? this.status,
      items: items ?? this.items,
      query: query ?? this.query,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
