import 'package:injectable/injectable.dart';

import 'clock.dart';

@lazySingleton
class StalePolicy {
  StalePolicy(this._clock);

  final Clock _clock;

  /// True if [fetchedAtUtc] is older than [maxAge].
  bool isStale({
    required DateTime fetchedAtUtc,
    required Duration maxAge,
  }) {
    final age = _clock.nowUtc().difference(fetchedAtUtc);
    return age > maxAge;
  }
}


