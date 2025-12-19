// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, name, updatedAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Currency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final String code;
  final String name;
  final DateTime updatedAtUtc;
  const Currency({
    required this.code,
    required this.name,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      code: Value(code),
      name: Value(name),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory Currency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  Currency copyWith({String? code, String? name, DateTime? updatedAtUtc}) =>
      Currency(
        code: code ?? this.code,
        name: name ?? this.name,
        updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, name, updatedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.code == this.code &&
          other.name == this.name &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<String> code;
  final Value<String> name;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    required String code,
    required String name,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<Currency> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith({
    Value<String>? code,
    Value<String>? name,
    Value<DateTime>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return CurrenciesCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [currencyCode, createdAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {currencyCode};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final String currencyCode;
  final DateTime createdAtUtc;
  const Favorite({required this.currencyCode, required this.createdAtUtc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['currency_code'] = Variable<String>(currencyCode);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      currencyCode: Value(currencyCode),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'currencyCode': serializer.toJson<String>(currencyCode),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
    };
  }

  Favorite copyWith({String? currencyCode, DateTime? createdAtUtc}) => Favorite(
    currencyCode: currencyCode ?? this.currencyCode,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(currencyCode, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.currencyCode == this.currencyCode &&
          other.createdAtUtc == this.createdAtUtc);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<String> currencyCode;
  final Value<DateTime> createdAtUtc;
  final Value<int> rowid;
  const FavoritesCompanion({
    this.currencyCode = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesCompanion.insert({
    required String currencyCode,
    required DateTime createdAtUtc,
    this.rowid = const Value.absent(),
  }) : currencyCode = Value(currencyCode),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<Favorite> custom({
    Expression<String>? currencyCode,
    Expression<DateTime>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (currencyCode != null) 'currency_code': currencyCode,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesCompanion copyWith({
    Value<String>? currencyCode,
    Value<DateTime>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return FavoritesCompanion(
      currencyCode: currencyCode ?? this.currencyCode,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LatestRatesTable extends LatestRates
    with TableInfo<$LatestRatesTable, LatestRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LatestRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fromCodeMeta = const VerificationMeta(
    'fromCode',
  );
  @override
  late final GeneratedColumn<String> fromCode = GeneratedColumn<String>(
    'from_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCodeMeta = const VerificationMeta('toCode');
  @override
  late final GeneratedColumn<String> toCode = GeneratedColumn<String>(
    'to_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtUtcMeta = const VerificationMeta(
    'fetchedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAtUtc = GeneratedColumn<DateTime>(
    'fetched_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fromCode, toCode, rate, fetchedAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'latest_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<LatestRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('from_code')) {
      context.handle(
        _fromCodeMeta,
        fromCode.isAcceptableOrUnknown(data['from_code']!, _fromCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_fromCodeMeta);
    }
    if (data.containsKey('to_code')) {
      context.handle(
        _toCodeMeta,
        toCode.isAcceptableOrUnknown(data['to_code']!, _toCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_toCodeMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('fetched_at_utc')) {
      context.handle(
        _fetchedAtUtcMeta,
        fetchedAtUtc.isAcceptableOrUnknown(
          data['fetched_at_utc']!,
          _fetchedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fromCode, toCode};
  @override
  LatestRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LatestRate(
      fromCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_code'],
      )!,
      toCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_code'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      fetchedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at_utc'],
      )!,
    );
  }

  @override
  $LatestRatesTable createAlias(String alias) {
    return $LatestRatesTable(attachedDatabase, alias);
  }
}

class LatestRate extends DataClass implements Insertable<LatestRate> {
  final String fromCode;
  final String toCode;
  final double rate;
  final DateTime fetchedAtUtc;
  const LatestRate({
    required this.fromCode,
    required this.toCode,
    required this.rate,
    required this.fetchedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['from_code'] = Variable<String>(fromCode);
    map['to_code'] = Variable<String>(toCode);
    map['rate'] = Variable<double>(rate);
    map['fetched_at_utc'] = Variable<DateTime>(fetchedAtUtc);
    return map;
  }

  LatestRatesCompanion toCompanion(bool nullToAbsent) {
    return LatestRatesCompanion(
      fromCode: Value(fromCode),
      toCode: Value(toCode),
      rate: Value(rate),
      fetchedAtUtc: Value(fetchedAtUtc),
    );
  }

  factory LatestRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LatestRate(
      fromCode: serializer.fromJson<String>(json['fromCode']),
      toCode: serializer.fromJson<String>(json['toCode']),
      rate: serializer.fromJson<double>(json['rate']),
      fetchedAtUtc: serializer.fromJson<DateTime>(json['fetchedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fromCode': serializer.toJson<String>(fromCode),
      'toCode': serializer.toJson<String>(toCode),
      'rate': serializer.toJson<double>(rate),
      'fetchedAtUtc': serializer.toJson<DateTime>(fetchedAtUtc),
    };
  }

  LatestRate copyWith({
    String? fromCode,
    String? toCode,
    double? rate,
    DateTime? fetchedAtUtc,
  }) => LatestRate(
    fromCode: fromCode ?? this.fromCode,
    toCode: toCode ?? this.toCode,
    rate: rate ?? this.rate,
    fetchedAtUtc: fetchedAtUtc ?? this.fetchedAtUtc,
  );
  LatestRate copyWithCompanion(LatestRatesCompanion data) {
    return LatestRate(
      fromCode: data.fromCode.present ? data.fromCode.value : this.fromCode,
      toCode: data.toCode.present ? data.toCode.value : this.toCode,
      rate: data.rate.present ? data.rate.value : this.rate,
      fetchedAtUtc: data.fetchedAtUtc.present
          ? data.fetchedAtUtc.value
          : this.fetchedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LatestRate(')
          ..write('fromCode: $fromCode, ')
          ..write('toCode: $toCode, ')
          ..write('rate: $rate, ')
          ..write('fetchedAtUtc: $fetchedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fromCode, toCode, rate, fetchedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LatestRate &&
          other.fromCode == this.fromCode &&
          other.toCode == this.toCode &&
          other.rate == this.rate &&
          other.fetchedAtUtc == this.fetchedAtUtc);
}

class LatestRatesCompanion extends UpdateCompanion<LatestRate> {
  final Value<String> fromCode;
  final Value<String> toCode;
  final Value<double> rate;
  final Value<DateTime> fetchedAtUtc;
  final Value<int> rowid;
  const LatestRatesCompanion({
    this.fromCode = const Value.absent(),
    this.toCode = const Value.absent(),
    this.rate = const Value.absent(),
    this.fetchedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LatestRatesCompanion.insert({
    required String fromCode,
    required String toCode,
    required double rate,
    required DateTime fetchedAtUtc,
    this.rowid = const Value.absent(),
  }) : fromCode = Value(fromCode),
       toCode = Value(toCode),
       rate = Value(rate),
       fetchedAtUtc = Value(fetchedAtUtc);
  static Insertable<LatestRate> custom({
    Expression<String>? fromCode,
    Expression<String>? toCode,
    Expression<double>? rate,
    Expression<DateTime>? fetchedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fromCode != null) 'from_code': fromCode,
      if (toCode != null) 'to_code': toCode,
      if (rate != null) 'rate': rate,
      if (fetchedAtUtc != null) 'fetched_at_utc': fetchedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LatestRatesCompanion copyWith({
    Value<String>? fromCode,
    Value<String>? toCode,
    Value<double>? rate,
    Value<DateTime>? fetchedAtUtc,
    Value<int>? rowid,
  }) {
    return LatestRatesCompanion(
      fromCode: fromCode ?? this.fromCode,
      toCode: toCode ?? this.toCode,
      rate: rate ?? this.rate,
      fetchedAtUtc: fetchedAtUtc ?? this.fetchedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fromCode.present) {
      map['from_code'] = Variable<String>(fromCode.value);
    }
    if (toCode.present) {
      map['to_code'] = Variable<String>(toCode.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (fetchedAtUtc.present) {
      map['fetched_at_utc'] = Variable<DateTime>(fetchedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LatestRatesCompanion(')
          ..write('fromCode: $fromCode, ')
          ..write('toCode: $toCode, ')
          ..write('rate: $rate, ')
          ..write('fetchedAtUtc: $fetchedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoricalRatesTable extends HistoricalRates
    with TableInfo<$HistoricalRatesTable, HistoricalRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricalRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fromCodeMeta = const VerificationMeta(
    'fromCode',
  );
  @override
  late final GeneratedColumn<String> fromCode = GeneratedColumn<String>(
    'from_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCodeMeta = const VerificationMeta('toCode');
  @override
  late final GeneratedColumn<String> toCode = GeneratedColumn<String>(
    'to_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtUtcMeta = const VerificationMeta(
    'fetchedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAtUtc = GeneratedColumn<DateTime>(
    'fetched_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    fromCode,
    toCode,
    date,
    rate,
    fetchedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historical_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoricalRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('from_code')) {
      context.handle(
        _fromCodeMeta,
        fromCode.isAcceptableOrUnknown(data['from_code']!, _fromCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_fromCodeMeta);
    }
    if (data.containsKey('to_code')) {
      context.handle(
        _toCodeMeta,
        toCode.isAcceptableOrUnknown(data['to_code']!, _toCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_toCodeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('fetched_at_utc')) {
      context.handle(
        _fetchedAtUtcMeta,
        fetchedAtUtc.isAcceptableOrUnknown(
          data['fetched_at_utc']!,
          _fetchedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fromCode, toCode, date};
  @override
  HistoricalRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricalRate(
      fromCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_code'],
      )!,
      toCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_code'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      fetchedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at_utc'],
      )!,
    );
  }

  @override
  $HistoricalRatesTable createAlias(String alias) {
    return $HistoricalRatesTable(attachedDatabase, alias);
  }
}

class HistoricalRate extends DataClass implements Insertable<HistoricalRate> {
  final String fromCode;
  final String toCode;
  final String date;
  final double rate;
  final DateTime fetchedAtUtc;
  const HistoricalRate({
    required this.fromCode,
    required this.toCode,
    required this.date,
    required this.rate,
    required this.fetchedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['from_code'] = Variable<String>(fromCode);
    map['to_code'] = Variable<String>(toCode);
    map['date'] = Variable<String>(date);
    map['rate'] = Variable<double>(rate);
    map['fetched_at_utc'] = Variable<DateTime>(fetchedAtUtc);
    return map;
  }

  HistoricalRatesCompanion toCompanion(bool nullToAbsent) {
    return HistoricalRatesCompanion(
      fromCode: Value(fromCode),
      toCode: Value(toCode),
      date: Value(date),
      rate: Value(rate),
      fetchedAtUtc: Value(fetchedAtUtc),
    );
  }

  factory HistoricalRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricalRate(
      fromCode: serializer.fromJson<String>(json['fromCode']),
      toCode: serializer.fromJson<String>(json['toCode']),
      date: serializer.fromJson<String>(json['date']),
      rate: serializer.fromJson<double>(json['rate']),
      fetchedAtUtc: serializer.fromJson<DateTime>(json['fetchedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fromCode': serializer.toJson<String>(fromCode),
      'toCode': serializer.toJson<String>(toCode),
      'date': serializer.toJson<String>(date),
      'rate': serializer.toJson<double>(rate),
      'fetchedAtUtc': serializer.toJson<DateTime>(fetchedAtUtc),
    };
  }

  HistoricalRate copyWith({
    String? fromCode,
    String? toCode,
    String? date,
    double? rate,
    DateTime? fetchedAtUtc,
  }) => HistoricalRate(
    fromCode: fromCode ?? this.fromCode,
    toCode: toCode ?? this.toCode,
    date: date ?? this.date,
    rate: rate ?? this.rate,
    fetchedAtUtc: fetchedAtUtc ?? this.fetchedAtUtc,
  );
  HistoricalRate copyWithCompanion(HistoricalRatesCompanion data) {
    return HistoricalRate(
      fromCode: data.fromCode.present ? data.fromCode.value : this.fromCode,
      toCode: data.toCode.present ? data.toCode.value : this.toCode,
      date: data.date.present ? data.date.value : this.date,
      rate: data.rate.present ? data.rate.value : this.rate,
      fetchedAtUtc: data.fetchedAtUtc.present
          ? data.fetchedAtUtc.value
          : this.fetchedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalRate(')
          ..write('fromCode: $fromCode, ')
          ..write('toCode: $toCode, ')
          ..write('date: $date, ')
          ..write('rate: $rate, ')
          ..write('fetchedAtUtc: $fetchedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fromCode, toCode, date, rate, fetchedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricalRate &&
          other.fromCode == this.fromCode &&
          other.toCode == this.toCode &&
          other.date == this.date &&
          other.rate == this.rate &&
          other.fetchedAtUtc == this.fetchedAtUtc);
}

class HistoricalRatesCompanion extends UpdateCompanion<HistoricalRate> {
  final Value<String> fromCode;
  final Value<String> toCode;
  final Value<String> date;
  final Value<double> rate;
  final Value<DateTime> fetchedAtUtc;
  final Value<int> rowid;
  const HistoricalRatesCompanion({
    this.fromCode = const Value.absent(),
    this.toCode = const Value.absent(),
    this.date = const Value.absent(),
    this.rate = const Value.absent(),
    this.fetchedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoricalRatesCompanion.insert({
    required String fromCode,
    required String toCode,
    required String date,
    required double rate,
    required DateTime fetchedAtUtc,
    this.rowid = const Value.absent(),
  }) : fromCode = Value(fromCode),
       toCode = Value(toCode),
       date = Value(date),
       rate = Value(rate),
       fetchedAtUtc = Value(fetchedAtUtc);
  static Insertable<HistoricalRate> custom({
    Expression<String>? fromCode,
    Expression<String>? toCode,
    Expression<String>? date,
    Expression<double>? rate,
    Expression<DateTime>? fetchedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fromCode != null) 'from_code': fromCode,
      if (toCode != null) 'to_code': toCode,
      if (date != null) 'date': date,
      if (rate != null) 'rate': rate,
      if (fetchedAtUtc != null) 'fetched_at_utc': fetchedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoricalRatesCompanion copyWith({
    Value<String>? fromCode,
    Value<String>? toCode,
    Value<String>? date,
    Value<double>? rate,
    Value<DateTime>? fetchedAtUtc,
    Value<int>? rowid,
  }) {
    return HistoricalRatesCompanion(
      fromCode: fromCode ?? this.fromCode,
      toCode: toCode ?? this.toCode,
      date: date ?? this.date,
      rate: rate ?? this.rate,
      fetchedAtUtc: fetchedAtUtc ?? this.fetchedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fromCode.present) {
      map['from_code'] = Variable<String>(fromCode.value);
    }
    if (toCode.present) {
      map['to_code'] = Variable<String>(toCode.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (fetchedAtUtc.present) {
      map['fetched_at_utc'] = Variable<DateTime>(fetchedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalRatesCompanion(')
          ..write('fromCode: $fromCode, ')
          ..write('toCode: $toCode, ')
          ..write('date: $date, ')
          ..write('rate: $rate, ')
          ..write('fetchedAtUtc: $fetchedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $LatestRatesTable latestRates = $LatestRatesTable(this);
  late final $HistoricalRatesTable historicalRates = $HistoricalRatesTable(
    this,
  );
  late final CurrenciesDao currenciesDao = CurrenciesDao(this as AppDatabase);
  late final FavoritesDao favoritesDao = FavoritesDao(this as AppDatabase);
  late final RatesDao ratesDao = RatesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    currencies,
    favorites,
    latestRates,
    historicalRates,
  ];
}

typedef $$CurrenciesTableCreateCompanionBuilder =
    CurrenciesCompanion Function({
      required String code,
      required String name,
      required DateTime updatedAtUtc,
      Value<int> rowid,
    });
typedef $$CurrenciesTableUpdateCompanionBuilder =
    CurrenciesCompanion Function({
      Value<String> code,
      Value<String> name,
      Value<DateTime> updatedAtUtc,
      Value<int> rowid,
    });

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );
}

class $$CurrenciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrenciesTable,
          Currency,
          $$CurrenciesTableFilterComposer,
          $$CurrenciesTableOrderingComposer,
          $$CurrenciesTableAnnotationComposer,
          $$CurrenciesTableCreateCompanionBuilder,
          $$CurrenciesTableUpdateCompanionBuilder,
          (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
          Currency,
          PrefetchHooks Function()
        > {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion(
                code: code,
                name: name,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String name,
                required DateTime updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion.insert(
                code: code,
                name: name,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurrenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrenciesTable,
      Currency,
      $$CurrenciesTableFilterComposer,
      $$CurrenciesTableOrderingComposer,
      $$CurrenciesTableAnnotationComposer,
      $$CurrenciesTableCreateCompanionBuilder,
      $$CurrenciesTableUpdateCompanionBuilder,
      (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
      Currency,
      PrefetchHooks Function()
    >;
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      required String currencyCode,
      required DateTime createdAtUtc,
      Value<int> rowid,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<String> currencyCode,
      Value<DateTime> createdAtUtc,
      Value<int> rowid,
    });

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
          Favorite,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion(
                currencyCode: currencyCode,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String currencyCode,
                required DateTime createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion.insert(
                currencyCode: currencyCode,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
      Favorite,
      PrefetchHooks Function()
    >;
typedef $$LatestRatesTableCreateCompanionBuilder =
    LatestRatesCompanion Function({
      required String fromCode,
      required String toCode,
      required double rate,
      required DateTime fetchedAtUtc,
      Value<int> rowid,
    });
typedef $$LatestRatesTableUpdateCompanionBuilder =
    LatestRatesCompanion Function({
      Value<String> fromCode,
      Value<String> toCode,
      Value<double> rate,
      Value<DateTime> fetchedAtUtc,
      Value<int> rowid,
    });

class $$LatestRatesTableFilterComposer
    extends Composer<_$AppDatabase, $LatestRatesTable> {
  $$LatestRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fromCode => $composableBuilder(
    column: $table.fromCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCode => $composableBuilder(
    column: $table.toCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LatestRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LatestRatesTable> {
  $$LatestRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fromCode => $composableBuilder(
    column: $table.fromCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCode => $composableBuilder(
    column: $table.toCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LatestRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LatestRatesTable> {
  $$LatestRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fromCode =>
      $composableBuilder(column: $table.fromCode, builder: (column) => column);

  GeneratedColumn<String> get toCode =>
      $composableBuilder(column: $table.toCode, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => column,
  );
}

class $$LatestRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LatestRatesTable,
          LatestRate,
          $$LatestRatesTableFilterComposer,
          $$LatestRatesTableOrderingComposer,
          $$LatestRatesTableAnnotationComposer,
          $$LatestRatesTableCreateCompanionBuilder,
          $$LatestRatesTableUpdateCompanionBuilder,
          (
            LatestRate,
            BaseReferences<_$AppDatabase, $LatestRatesTable, LatestRate>,
          ),
          LatestRate,
          PrefetchHooks Function()
        > {
  $$LatestRatesTableTableManager(_$AppDatabase db, $LatestRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LatestRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LatestRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LatestRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fromCode = const Value.absent(),
                Value<String> toCode = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<DateTime> fetchedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LatestRatesCompanion(
                fromCode: fromCode,
                toCode: toCode,
                rate: rate,
                fetchedAtUtc: fetchedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fromCode,
                required String toCode,
                required double rate,
                required DateTime fetchedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => LatestRatesCompanion.insert(
                fromCode: fromCode,
                toCode: toCode,
                rate: rate,
                fetchedAtUtc: fetchedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LatestRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LatestRatesTable,
      LatestRate,
      $$LatestRatesTableFilterComposer,
      $$LatestRatesTableOrderingComposer,
      $$LatestRatesTableAnnotationComposer,
      $$LatestRatesTableCreateCompanionBuilder,
      $$LatestRatesTableUpdateCompanionBuilder,
      (
        LatestRate,
        BaseReferences<_$AppDatabase, $LatestRatesTable, LatestRate>,
      ),
      LatestRate,
      PrefetchHooks Function()
    >;
typedef $$HistoricalRatesTableCreateCompanionBuilder =
    HistoricalRatesCompanion Function({
      required String fromCode,
      required String toCode,
      required String date,
      required double rate,
      required DateTime fetchedAtUtc,
      Value<int> rowid,
    });
typedef $$HistoricalRatesTableUpdateCompanionBuilder =
    HistoricalRatesCompanion Function({
      Value<String> fromCode,
      Value<String> toCode,
      Value<String> date,
      Value<double> rate,
      Value<DateTime> fetchedAtUtc,
      Value<int> rowid,
    });

class $$HistoricalRatesTableFilterComposer
    extends Composer<_$AppDatabase, $HistoricalRatesTable> {
  $$HistoricalRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fromCode => $composableBuilder(
    column: $table.fromCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCode => $composableBuilder(
    column: $table.toCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoricalRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoricalRatesTable> {
  $$HistoricalRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fromCode => $composableBuilder(
    column: $table.fromCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCode => $composableBuilder(
    column: $table.toCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoricalRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoricalRatesTable> {
  $$HistoricalRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fromCode =>
      $composableBuilder(column: $table.fromCode, builder: (column) => column);

  GeneratedColumn<String> get toCode =>
      $composableBuilder(column: $table.toCode, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAtUtc => $composableBuilder(
    column: $table.fetchedAtUtc,
    builder: (column) => column,
  );
}

class $$HistoricalRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoricalRatesTable,
          HistoricalRate,
          $$HistoricalRatesTableFilterComposer,
          $$HistoricalRatesTableOrderingComposer,
          $$HistoricalRatesTableAnnotationComposer,
          $$HistoricalRatesTableCreateCompanionBuilder,
          $$HistoricalRatesTableUpdateCompanionBuilder,
          (
            HistoricalRate,
            BaseReferences<
              _$AppDatabase,
              $HistoricalRatesTable,
              HistoricalRate
            >,
          ),
          HistoricalRate,
          PrefetchHooks Function()
        > {
  $$HistoricalRatesTableTableManager(
    _$AppDatabase db,
    $HistoricalRatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricalRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricalRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoricalRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fromCode = const Value.absent(),
                Value<String> toCode = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<DateTime> fetchedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoricalRatesCompanion(
                fromCode: fromCode,
                toCode: toCode,
                date: date,
                rate: rate,
                fetchedAtUtc: fetchedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fromCode,
                required String toCode,
                required String date,
                required double rate,
                required DateTime fetchedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => HistoricalRatesCompanion.insert(
                fromCode: fromCode,
                toCode: toCode,
                date: date,
                rate: rate,
                fetchedAtUtc: fetchedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoricalRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoricalRatesTable,
      HistoricalRate,
      $$HistoricalRatesTableFilterComposer,
      $$HistoricalRatesTableOrderingComposer,
      $$HistoricalRatesTableAnnotationComposer,
      $$HistoricalRatesTableCreateCompanionBuilder,
      $$HistoricalRatesTableUpdateCompanionBuilder,
      (
        HistoricalRate,
        BaseReferences<_$AppDatabase, $HistoricalRatesTable, HistoricalRate>,
      ),
      HistoricalRate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$LatestRatesTableTableManager get latestRates =>
      $$LatestRatesTableTableManager(_db, _db.latestRates);
  $$HistoricalRatesTableTableManager get historicalRates =>
      $$HistoricalRatesTableTableManager(_db, _db.historicalRates);
}
