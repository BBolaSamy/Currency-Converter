import 'package:injectable/injectable.dart';

import '../../../../core/result/result.dart';
import '../entities/rate_point.dart';
import '../repositories/rates_repository.dart';

@injectable
class GetLast7Days {
  const GetLast7Days(this._repo);
  final RatesRepository _repo;

  Future<Result<List<RatePoint>>> call({
    required String from,
    required String to,
    bool forceRefresh = false,
  }) {
    return _repo.getLast7Days(from: from, to: to, forceRefresh: forceRefresh);
  }
}
