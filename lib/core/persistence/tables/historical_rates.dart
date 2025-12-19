import 'package:drift/drift.dart';

class HistoricalRates extends Table {
  TextColumn get fromCode => text()();
  TextColumn get toCode => text()();
  TextColumn get date => text()(); // YYYY-MM-DD
  RealColumn get rate => real()();
  DateTimeColumn get fetchedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {fromCode, toCode, date};
}


