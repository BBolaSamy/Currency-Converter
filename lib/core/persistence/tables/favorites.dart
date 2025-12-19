import 'package:drift/drift.dart';

class Favorites extends Table {
  TextColumn get currencyCode => text()();
  DateTimeColumn get createdAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {currencyCode};
}


