// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PatientEntriesTable extends PatientEntries
    with TableInfo<$PatientEntriesTable, PatientEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
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
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomsTextMeta = const VerificationMeta(
    'symptomsText',
  );
  @override
  late final GeneratedColumn<String> symptomsText = GeneratedColumn<String>(
    'symptoms_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ashaWorkerIdMeta = const VerificationMeta(
    'ashaWorkerId',
  );
  @override
  late final GeneratedColumn<String> ashaWorkerId = GeneratedColumn<String>(
    'asha_worker_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urgencyScoreMeta = const VerificationMeta(
    'urgencyScore',
  );
  @override
  late final GeneratedColumn<String> urgencyScore = GeneratedColumn<String>(
    'urgency_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiSummaryMeta = const VerificationMeta(
    'aiSummary',
  );
  @override
  late final GeneratedColumn<String> aiSummary = GeneratedColumn<String>(
    'ai_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localId,
    name,
    age,
    gender,
    language,
    symptomsText,
    ashaWorkerId,
    urgencyScore,
    aiSummary,
    createdAt,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PatientEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('symptoms_text')) {
      context.handle(
        _symptomsTextMeta,
        symptomsText.isAcceptableOrUnknown(
          data['symptoms_text']!,
          _symptomsTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_symptomsTextMeta);
    }
    if (data.containsKey('asha_worker_id')) {
      context.handle(
        _ashaWorkerIdMeta,
        ashaWorkerId.isAcceptableOrUnknown(
          data['asha_worker_id']!,
          _ashaWorkerIdMeta,
        ),
      );
    }
    if (data.containsKey('urgency_score')) {
      context.handle(
        _urgencyScoreMeta,
        urgencyScore.isAcceptableOrUnknown(
          data['urgency_score']!,
          _urgencyScoreMeta,
        ),
      );
    }
    if (data.containsKey('ai_summary')) {
      context.handle(
        _aiSummaryMeta,
        aiSummary.isAcceptableOrUnknown(data['ai_summary']!, _aiSummaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  PatientEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      ),
      localId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      age:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}age'],
          )!,
      gender:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}gender'],
          )!,
      language:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}language'],
          )!,
      symptomsText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}symptoms_text'],
          )!,
      ashaWorkerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asha_worker_id'],
      ),
      urgencyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urgency_score'],
      ),
      aiSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_summary'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      synced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}synced'],
          )!,
    );
  }

  @override
  $PatientEntriesTable createAlias(String alias) {
    return $PatientEntriesTable(attachedDatabase, alias);
  }
}

class PatientEntry extends DataClass implements Insertable<PatientEntry> {
  final String? id;
  final String localId;
  final String name;
  final int age;
  final String gender;
  final String language;
  final String symptomsText;
  final String? ashaWorkerId;
  final String? urgencyScore;
  final String? aiSummary;
  final DateTime? createdAt;
  final bool synced;
  const PatientEntry({
    this.id,
    required this.localId,
    required this.name,
    required this.age,
    required this.gender,
    required this.language,
    required this.symptomsText,
    this.ashaWorkerId,
    this.urgencyScore,
    this.aiSummary,
    this.createdAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['local_id'] = Variable<String>(localId);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['gender'] = Variable<String>(gender);
    map['language'] = Variable<String>(language);
    map['symptoms_text'] = Variable<String>(symptomsText);
    if (!nullToAbsent || ashaWorkerId != null) {
      map['asha_worker_id'] = Variable<String>(ashaWorkerId);
    }
    if (!nullToAbsent || urgencyScore != null) {
      map['urgency_score'] = Variable<String>(urgencyScore);
    }
    if (!nullToAbsent || aiSummary != null) {
      map['ai_summary'] = Variable<String>(aiSummary);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  PatientEntriesCompanion toCompanion(bool nullToAbsent) {
    return PatientEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      localId: Value(localId),
      name: Value(name),
      age: Value(age),
      gender: Value(gender),
      language: Value(language),
      symptomsText: Value(symptomsText),
      ashaWorkerId:
          ashaWorkerId == null && nullToAbsent
              ? const Value.absent()
              : Value(ashaWorkerId),
      urgencyScore:
          urgencyScore == null && nullToAbsent
              ? const Value.absent()
              : Value(urgencyScore),
      aiSummary:
          aiSummary == null && nullToAbsent
              ? const Value.absent()
              : Value(aiSummary),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
      synced: Value(synced),
    );
  }

  factory PatientEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientEntry(
      id: serializer.fromJson<String?>(json['id']),
      localId: serializer.fromJson<String>(json['localId']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String>(json['gender']),
      language: serializer.fromJson<String>(json['language']),
      symptomsText: serializer.fromJson<String>(json['symptomsText']),
      ashaWorkerId: serializer.fromJson<String?>(json['ashaWorkerId']),
      urgencyScore: serializer.fromJson<String?>(json['urgencyScore']),
      aiSummary: serializer.fromJson<String?>(json['aiSummary']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'localId': serializer.toJson<String>(localId),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String>(gender),
      'language': serializer.toJson<String>(language),
      'symptomsText': serializer.toJson<String>(symptomsText),
      'ashaWorkerId': serializer.toJson<String?>(ashaWorkerId),
      'urgencyScore': serializer.toJson<String?>(urgencyScore),
      'aiSummary': serializer.toJson<String?>(aiSummary),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  PatientEntry copyWith({
    Value<String?> id = const Value.absent(),
    String? localId,
    String? name,
    int? age,
    String? gender,
    String? language,
    String? symptomsText,
    Value<String?> ashaWorkerId = const Value.absent(),
    Value<String?> urgencyScore = const Value.absent(),
    Value<String?> aiSummary = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    bool? synced,
  }) => PatientEntry(
    id: id.present ? id.value : this.id,
    localId: localId ?? this.localId,
    name: name ?? this.name,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    language: language ?? this.language,
    symptomsText: symptomsText ?? this.symptomsText,
    ashaWorkerId: ashaWorkerId.present ? ashaWorkerId.value : this.ashaWorkerId,
    urgencyScore: urgencyScore.present ? urgencyScore.value : this.urgencyScore,
    aiSummary: aiSummary.present ? aiSummary.value : this.aiSummary,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    synced: synced ?? this.synced,
  );
  PatientEntry copyWithCompanion(PatientEntriesCompanion data) {
    return PatientEntry(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      language: data.language.present ? data.language.value : this.language,
      symptomsText:
          data.symptomsText.present
              ? data.symptomsText.value
              : this.symptomsText,
      ashaWorkerId:
          data.ashaWorkerId.present
              ? data.ashaWorkerId.value
              : this.ashaWorkerId,
      urgencyScore:
          data.urgencyScore.present
              ? data.urgencyScore.value
              : this.urgencyScore,
      aiSummary: data.aiSummary.present ? data.aiSummary.value : this.aiSummary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientEntry(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('language: $language, ')
          ..write('symptomsText: $symptomsText, ')
          ..write('ashaWorkerId: $ashaWorkerId, ')
          ..write('urgencyScore: $urgencyScore, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localId,
    name,
    age,
    gender,
    language,
    symptomsText,
    ashaWorkerId,
    urgencyScore,
    aiSummary,
    createdAt,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientEntry &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.language == this.language &&
          other.symptomsText == this.symptomsText &&
          other.ashaWorkerId == this.ashaWorkerId &&
          other.urgencyScore == this.urgencyScore &&
          other.aiSummary == this.aiSummary &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class PatientEntriesCompanion extends UpdateCompanion<PatientEntry> {
  final Value<String?> id;
  final Value<String> localId;
  final Value<String> name;
  final Value<int> age;
  final Value<String> gender;
  final Value<String> language;
  final Value<String> symptomsText;
  final Value<String?> ashaWorkerId;
  final Value<String?> urgencyScore;
  final Value<String?> aiSummary;
  final Value<DateTime?> createdAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const PatientEntriesCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.language = const Value.absent(),
    this.symptomsText = const Value.absent(),
    this.ashaWorkerId = const Value.absent(),
    this.urgencyScore = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String localId,
    required String name,
    required int age,
    required String gender,
    required String language,
    required String symptomsText,
    this.ashaWorkerId = const Value.absent(),
    this.urgencyScore = const Value.absent(),
    this.aiSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       name = Value(name),
       age = Value(age),
       gender = Value(gender),
       language = Value(language),
       symptomsText = Value(symptomsText);
  static Insertable<PatientEntry> custom({
    Expression<String>? id,
    Expression<String>? localId,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? language,
    Expression<String>? symptomsText,
    Expression<String>? ashaWorkerId,
    Expression<String>? urgencyScore,
    Expression<String>? aiSummary,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (language != null) 'language': language,
      if (symptomsText != null) 'symptoms_text': symptomsText,
      if (ashaWorkerId != null) 'asha_worker_id': ashaWorkerId,
      if (urgencyScore != null) 'urgency_score': urgencyScore,
      if (aiSummary != null) 'ai_summary': aiSummary,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientEntriesCompanion copyWith({
    Value<String?>? id,
    Value<String>? localId,
    Value<String>? name,
    Value<int>? age,
    Value<String>? gender,
    Value<String>? language,
    Value<String>? symptomsText,
    Value<String?>? ashaWorkerId,
    Value<String?>? urgencyScore,
    Value<String?>? aiSummary,
    Value<DateTime?>? createdAt,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return PatientEntriesCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      symptomsText: symptomsText ?? this.symptomsText,
      ashaWorkerId: ashaWorkerId ?? this.ashaWorkerId,
      urgencyScore: urgencyScore ?? this.urgencyScore,
      aiSummary: aiSummary ?? this.aiSummary,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (symptomsText.present) {
      map['symptoms_text'] = Variable<String>(symptomsText.value);
    }
    if (ashaWorkerId.present) {
      map['asha_worker_id'] = Variable<String>(ashaWorkerId.value);
    }
    if (urgencyScore.present) {
      map['urgency_score'] = Variable<String>(urgencyScore.value);
    }
    if (aiSummary.present) {
      map['ai_summary'] = Variable<String>(aiSummary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientEntriesCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('language: $language, ')
          ..write('symptomsText: $symptomsText, ')
          ..write('ashaWorkerId: $ashaWorkerId, ')
          ..write('urgencyScore: $urgencyScore, ')
          ..write('aiSummary: $aiSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientEntriesTable patientEntries = $PatientEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [patientEntries];
}

typedef $$PatientEntriesTableCreateCompanionBuilder =
    PatientEntriesCompanion Function({
      Value<String?> id,
      required String localId,
      required String name,
      required int age,
      required String gender,
      required String language,
      required String symptomsText,
      Value<String?> ashaWorkerId,
      Value<String?> urgencyScore,
      Value<String?> aiSummary,
      Value<DateTime?> createdAt,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$PatientEntriesTableUpdateCompanionBuilder =
    PatientEntriesCompanion Function({
      Value<String?> id,
      Value<String> localId,
      Value<String> name,
      Value<int> age,
      Value<String> gender,
      Value<String> language,
      Value<String> symptomsText,
      Value<String?> ashaWorkerId,
      Value<String?> urgencyScore,
      Value<String?> aiSummary,
      Value<DateTime?> createdAt,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$PatientEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientEntriesTable> {
  $$PatientEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptomsText => $composableBuilder(
    column: $table.symptomsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ashaWorkerId => $composableBuilder(
    column: $table.ashaWorkerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urgencyScore => $composableBuilder(
    column: $table.urgencyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PatientEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientEntriesTable> {
  $$PatientEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptomsText => $composableBuilder(
    column: $table.symptomsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ashaWorkerId => $composableBuilder(
    column: $table.ashaWorkerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urgencyScore => $composableBuilder(
    column: $table.urgencyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiSummary => $composableBuilder(
    column: $table.aiSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientEntriesTable> {
  $$PatientEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get symptomsText => $composableBuilder(
    column: $table.symptomsText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ashaWorkerId => $composableBuilder(
    column: $table.ashaWorkerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get urgencyScore => $composableBuilder(
    column: $table.urgencyScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiSummary =>
      $composableBuilder(column: $table.aiSummary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$PatientEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientEntriesTable,
          PatientEntry,
          $$PatientEntriesTableFilterComposer,
          $$PatientEntriesTableOrderingComposer,
          $$PatientEntriesTableAnnotationComposer,
          $$PatientEntriesTableCreateCompanionBuilder,
          $$PatientEntriesTableUpdateCompanionBuilder,
          (
            PatientEntry,
            BaseReferences<_$AppDatabase, $PatientEntriesTable, PatientEntry>,
          ),
          PatientEntry,
          PrefetchHooks Function()
        > {
  $$PatientEntriesTableTableManager(
    _$AppDatabase db,
    $PatientEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PatientEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$PatientEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PatientEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                Value<String> localId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> symptomsText = const Value.absent(),
                Value<String?> ashaWorkerId = const Value.absent(),
                Value<String?> urgencyScore = const Value.absent(),
                Value<String?> aiSummary = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientEntriesCompanion(
                id: id,
                localId: localId,
                name: name,
                age: age,
                gender: gender,
                language: language,
                symptomsText: symptomsText,
                ashaWorkerId: ashaWorkerId,
                urgencyScore: urgencyScore,
                aiSummary: aiSummary,
                createdAt: createdAt,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                required String localId,
                required String name,
                required int age,
                required String gender,
                required String language,
                required String symptomsText,
                Value<String?> ashaWorkerId = const Value.absent(),
                Value<String?> urgencyScore = const Value.absent(),
                Value<String?> aiSummary = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientEntriesCompanion.insert(
                id: id,
                localId: localId,
                name: name,
                age: age,
                gender: gender,
                language: language,
                symptomsText: symptomsText,
                ashaWorkerId: ashaWorkerId,
                urgencyScore: urgencyScore,
                aiSummary: aiSummary,
                createdAt: createdAt,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PatientEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientEntriesTable,
      PatientEntry,
      $$PatientEntriesTableFilterComposer,
      $$PatientEntriesTableOrderingComposer,
      $$PatientEntriesTableAnnotationComposer,
      $$PatientEntriesTableCreateCompanionBuilder,
      $$PatientEntriesTableUpdateCompanionBuilder,
      (
        PatientEntry,
        BaseReferences<_$AppDatabase, $PatientEntriesTable, PatientEntry>,
      ),
      PatientEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientEntriesTableTableManager get patientEntries =>
      $$PatientEntriesTableTableManager(_db, _db.patientEntries);
}
