import 'package:drift/drift.dart';

class LatestRates extends Table {
  TextColumn get fromCode => text()();
  TextColumn get toCode => text()();
  RealColumn get rate => real()();
  DateTimeColumn get fetchedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {fromCode, toCode};
}


