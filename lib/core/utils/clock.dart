import 'package:injectable/injectable.dart';

@lazySingleton
class Clock {
  DateTime nowUtc() => DateTime.now().toUtc();
}


