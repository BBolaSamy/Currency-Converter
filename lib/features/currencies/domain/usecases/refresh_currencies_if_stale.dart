import '../../../../core/result/result.dart';
import '../repositories/currencies_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RefreshCurrenciesIfStale {
  const RefreshCurrenciesIfStale(this._repo);
  final CurrenciesRepository _repo;

  Future<Result<void>> call() => _repo.refreshCurrenciesIfStale();
}
