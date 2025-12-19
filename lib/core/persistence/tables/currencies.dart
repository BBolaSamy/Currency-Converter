import 'package:drift/drift.dart';

class Currencies extends Table {
  TextColumn get code => text()(); // e.g. USD
  TextColumn get name => text()(); // e.g. United States Dollar
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}


