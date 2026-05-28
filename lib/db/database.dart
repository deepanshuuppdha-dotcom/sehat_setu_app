import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sehat_setu/models/patient.dart' as model;

part 'database.g.dart';

/// Drift table for local patient storage
class PatientEntries extends Table {
  TextColumn get id => text().nullable()();
  TextColumn get localId => text()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();
  TextColumn get language => text()();
  TextColumn get symptomsText => text()();
  TextColumn get ashaWorkerId => text().nullable()();
  TextColumn get urgencyScore => text().nullable()();
  TextColumn get aiSummary => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {localId};
}

@DriftDatabase(tables: [PatientEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'sehat_setu_db');
  }

  // --------------- CRUD helpers ---------------

  Future<void> insertPatientModel(model.Patient patient) {
    return into(patientEntries).insertOnConflictUpdate(
      PatientEntriesCompanion.insert(
        localId: patient.localId,
        name: patient.name,
        age: patient.age,
        gender: patient.gender,
        language: patient.language,
        symptomsText: patient.symptomsText,
        id: Value(patient.id),
        ashaWorkerId: Value(patient.ashaWorkerId),
        urgencyScore: Value(patient.urgencyScore),
        aiSummary: Value(patient.aiSummary),
        createdAt: Value(patient.createdAt),
        synced: Value(patient.synced),
      ),
    );
  }

  Future<List<model.Patient>> getAllPatients() async {
    final rows = await (select(patientEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Future<List<model.Patient>> getUnsyncedPatients() async {
    final rows = await (select(patientEntries)
          ..where((t) => t.synced.equals(false)))
        .get();
    return rows.map(_toModel).toList();
  }

  Stream<List<model.Patient>> watchAllPatients() {
    return (select(patientEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_toModel).toList());
  }

  Future<void> markAsSynced(
    String localId, {
    String? serverId,
    String? urgencyScore,
    String? aiSummary,
  }) {
    return (update(patientEntries)..where((t) => t.localId.equals(localId)))
        .write(PatientEntriesCompanion(
      synced: const Value(true),
      id: serverId != null ? Value(serverId) : const Value.absent(),
      urgencyScore:
          urgencyScore != null ? Value(urgencyScore) : const Value.absent(),
      aiSummary: aiSummary != null ? Value(aiSummary) : const Value.absent(),
    ));
  }

  // --------------- Mapping ---------------

  model.Patient _toModel(PatientEntry e) {
    return model.Patient(
      id: e.id,
      localId: e.localId,
      name: e.name,
      age: e.age,
      gender: e.gender,
      language: e.language,
      symptomsText: e.symptomsText,
      ashaWorkerId: e.ashaWorkerId,
      urgencyScore: e.urgencyScore,
      aiSummary: e.aiSummary,
      createdAt: e.createdAt,
      synced: e.synced,
    );
  }
}
