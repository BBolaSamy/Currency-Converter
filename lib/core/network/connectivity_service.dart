import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'connectivity_status.dart';

@lazySingleton
class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  Stream<ConnectivityStatus> watchStatus() {
    return _connectivity.onConnectivityChanged.map(_mapResult);
  }

  Future<ConnectivityStatus> getCurrentStatus() async {
    final result = await _connectivity.checkConnectivity();
    return _mapResult(result);
  }

  ConnectivityStatus _mapResult(List<ConnectivityResult> results) {
    final isOffline =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    return isOffline ? ConnectivityStatus.offline : ConnectivityStatus.online;
  }
}
