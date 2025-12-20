import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'connectivity_service.dart';
import 'connectivity_status.dart';

@injectable
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit(this._service) : super(ConnectivityStatus.online) {
    _init();
  }

  final ConnectivityService _service;
  StreamSubscription<ConnectivityStatus>? _sub;

  Future<void> _init() async {
    emit(await _service.getCurrentStatus());
    _sub = _service.watchStatus().listen(emit);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
