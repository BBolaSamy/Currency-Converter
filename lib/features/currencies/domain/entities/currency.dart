import '../../../../core/domain/entities/currency_entity.dart';

class CurrencyItem {
  const CurrencyItem({required this.currency, required this.isFavorite});

  final CurrencyEntity currency;
  final bool isFavorite;
}
