import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sehat_setu/models/patient.dart';

class ApiService {
  /// ⚠️  Replace SAKSHAM_IP with your teammate's actual IP before running
  static const String baseUrl = 'http://192.168.0.102:8000/api';

  // ---------- POST /submit-patient ----------
  Future<Patient?> submitPatient(Patient patient) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/submit-patient'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(patient.toSubmitJson()),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Patient.fromResponse(jsonDecode(response.body));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ---------- POST /transcribe ----------
  Future<String?> transcribeAudio(String filePath, String language) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/transcribe'),
      );
      request.fields['language'] = language;
      request.files.add(
        await http.MultipartFile.fromPath('audio', filePath),
      );

      final streamed = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['transcribed_text'] ?? data['text'] ?? data['transcription'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ---------- POST /sync-patients ----------
  Future<List<Patient>> syncOfflineQueue(List<Patient> patients) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/sync-patients'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'patients': patients.map((p) => p.toSubmitJson()).toList(),
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final List items = data is List ? data : (data['patients'] ?? []);
        return items.map<Patient>((j) => Patient.fromResponse(j)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ---------- POST /login ----------
  Future<Map<String, dynamic>?> login(String phone, String pin) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': phone, 'pin': pin}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
  // ---------- GET /prescriptions/{patientId} ----------
  Future<List<dynamic>?> getPrescriptions(String patientId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/prescriptions/$patientId'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
