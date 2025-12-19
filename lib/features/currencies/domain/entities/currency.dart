class CurrencyEntity {
  const CurrencyEntity({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;
}

class CurrencyItem {
  const CurrencyItem({
    required this.currency,
    required this.isFavorite,
  });

  final CurrencyEntity currency;
  final bool isFavorite;
}


