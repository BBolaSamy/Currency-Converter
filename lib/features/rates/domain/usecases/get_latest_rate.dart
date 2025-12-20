import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../entities/latest_rate_quote.dart';
import '../repositories/rates_repository.dart';

@injectable
class GetLatestRate {
  const GetLatestRate(this._repo);
  final RatesRepository _repo;

  Future<Result<LatestRateQuote>> call({
    required String from,
    required String to,
    bool forceRefresh = false,
  }) {
    return _repo.getLatestRate(from: from, to: to, forceRefresh: forceRefresh);
  }
}
