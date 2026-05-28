import 'package:uuid/uuid.dart';

class Patient {
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
  final String? phone;        // ADD THIS

  Patient({
    this.id,
    String? localId,
    required this.name,
    required this.age,
    required this.gender,
    required this.language,
    required this.symptomsText,
    this.ashaWorkerId,
    this.urgencyScore,
    this.aiSummary,
    this.createdAt,
    this.synced = false,
    this.phone,               // ADD THIS
  }) : localId = localId ?? const Uuid().v4();

  Map<String, dynamic> toSubmitJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'language': language,
      'symptoms_text': symptomsText,
      'asha_worker_id': ashaWorkerId,
      'local_id': localId,
      'phone': phone,          // ADD THIS
    };
  }

  factory Patient.fromResponse(Map<String, dynamic> json) {
    return Patient(
      id: json['id']?.toString(),
      localId: json['local_id']?.toString() ?? const Uuid().v4(),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'other',
      language: json['language'] ?? 'en',
      symptomsText: json['symptoms_text'] ?? '',
      urgencyScore: json['urgency_score'],
      aiSummary: json['ai_summary'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : DateTime.now(),
      synced: json['synced'] ?? true,
      phone: json['phone'],    // ADD THIS
    );
  }

  Patient copyWith({
    String? id,
    String? localId,
    String? name,
    int? age,
    String? gender,
    String? language,
    String? symptomsText,
    String? ashaWorkerId,
    String? urgencyScore,
    String? aiSummary,
    DateTime? createdAt,
    bool? synced,
    String? phone,             // ADD THIS
  }) {
    return Patient(
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
      phone: phone ?? this.phone,  // ADD THIS
    );
  }
}