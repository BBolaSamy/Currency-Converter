import '../entities/currency.dart';
import '../repositories/currencies_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchCurrencies {
  const WatchCurrencies(this._repo);
  final CurrenciesRepository _repo;

  Stream<List<CurrencyItem>> call() => _repo.watchCurrencies();
}
