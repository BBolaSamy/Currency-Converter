import '../../../../core/result/result.dart';
import '../entities/currency.dart';

abstract class CurrenciesRepository {
  Stream<List<CurrencyItem>> watchCurrencies();

  /// Triggers a refresh if possible; returns Success even if it decides no refresh is needed.
  Future<Result<void>> refreshCurrenciesIfStale();

  Future<Result<void>> setFavorite({
    required String currencyCode,
    required bool isFavorite,
  });
}


