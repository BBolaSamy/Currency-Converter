import '../../../../core/result/result.dart';
import '../repositories/currencies_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetCurrencyFavorite {
  const SetCurrencyFavorite(this._repo);
  final CurrenciesRepository _repo;

  Future<Result<void>> call({
    required String currencyCode,
    required bool isFavorite,
  }) {
    return _repo.setFavorite(
      currencyCode: currencyCode,
      isFavorite: isFavorite,
    );
  }
}
