import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sehat_setu/db/database.dart';
import 'package:sehat_setu/models/patient.dart';
import 'package:sehat_setu/services/api_service.dart';
import 'package:sehat_setu/services/sync_service.dart';

class PatientIntakeScreen extends StatefulWidget {
  final String? ashaWorkerId;
  const PatientIntakeScreen({super.key, this.ashaWorkerId});

  @override
  State<PatientIntakeScreen> createState() => _PatientIntakeScreenState();
}

class _PatientIntakeScreenState extends State<PatientIntakeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _symptomsCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();  // ADD THIS

  String _language = 'hi';
  String _gender = 'male';
  bool _isRecording = false;
  bool _isTranscribing = false;
  bool _isSubmitting = false;
  bool _recorderReady = false;

  FlutterSoundRecorder? _recorder;

  final Map<String, String> _languages = {
    'hi': 'Hindi (हिन्दी)',
    'ta': 'Tamil (தமிழ்)',
    'mr': 'Marathi (मराठी)',
    'en': 'English',
    'bn': 'Bengali (বাংলা)',
    'te': 'Telugu (తెలుగు)',
    'kn': 'Kannada (ಕನ್ನಡ)',
  };

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
  }

  Future<void> _openRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _recorder!.openRecorder();
      if (mounted) setState(() => _recorderReady = true);
    } else {
      final status2 = await Permission.microphone.request();
      if (status2.isGranted) {
        await _recorder!.openRecorder();
        if (mounted) setState(() => _recorderReady = true);
      }
    }
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _symptomsCtrl.dispose();
    _phoneCtrl.dispose();  // ADD THIS
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (!_recorderReady) return;

    if (_isRecording) {
      final path = await _recorder!.stopRecorder();
      setState(() => _isRecording = false);

      if (path != null) {
        setState(() => _isTranscribing = true);
        final text = await ApiService().transcribeAudio(path, _language);
        if (mounted) {
          setState(() {
            _isTranscribing = false;
            if (text != null) _symptomsCtrl.text = text;
          });
          if (text == null) {
            _snack('Transcription failed — please type manually', Colors.red);
          } else {
            _snack('✅ Voice transcribed!', const Color(0xFF1D9E75));
          }
        }
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder!.startRecorder(toFile: filePath, codec: Codec.aacMP4);
      setState(() => _isRecording = true);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final patient = Patient(
      name: _nameCtrl.text.trim(),
      age: int.parse(_ageCtrl.text.trim()),
      gender: _gender,
      language: _language,
      symptomsText: _symptomsCtrl.text.trim(),
      ashaWorkerId: widget.ashaWorkerId,
      createdAt: DateTime.now(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(), // ADD THIS
    );

    final sync = context.read<SyncService>();
    final db = context.read<AppDatabase>();

    if (sync.isOnline) {
      final result = await ApiService().submitPatient(patient);
      if (result != null && mounted) {
        await db.insertPatientModel(result.copyWith(synced: true));
        _snack('✅ Submitted — Urgency: ${result.urgencyScore}',
            const Color(0xFF1D9E75));
        if (mounted) Navigator.pop(context);
        return;
      }
    }

    await db.insertPatientModel(patient);
    if (mounted) {
      _snack('📱 Saved offline — will sync automatically',
          const Color(0xFFF59E0B));
      Navigator.pop(context);
    }
  }

  void _snack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),
      appBar: AppBar(
        title: const Text('New Patient'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF2ECDA7)),
                  SizedBox(height: 20),
                  Text('AI is analyzing symptoms…',
                      style: TextStyle(color: Colors.white70, fontSize: 15)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Language / भाषा'),
                    const SizedBox(height: 8),
                    _dropdownCard(
                      value: _language,
                      items: _languages.entries
                          .map((e) => DropdownMenuItem(
                              value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: (v) => setState(() => _language = v!),
                    ),
                    const SizedBox(height: 22),

                    _label('Patient Name'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _nameCtrl,
                      hint: 'Full name',
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Age'),
                              const SizedBox(height: 8),
                              _textField(
                                controller: _ageCtrl,
                                hint: 'Age',
                                keyboard: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Required';
                                  if (int.tryParse(v) == null) return 'Invalid';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Gender'),
                              const SizedBox(height: 8),
                              _dropdownCard<String>(
                                value: _gender,
                                items: const [
                                  DropdownMenuItem(value: 'male', child: Text('Male')),
                                  DropdownMenuItem(value: 'female', child: Text('Female')),
                                  DropdownMenuItem(value: 'other', child: Text('Other')),
                                ],
                                onChanged: (v) => setState(() => _gender = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    // PHONE FIELD
                    _label('Mobile Number / मोबाइल नंबर'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _phoneCtrl,
                      hint: '10-digit mobile number',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 22),

                    _label('Symptoms / लक्षण'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _symptomsCtrl,
                      hint: 'Describe symptoms in patient\'s language…',
                      maxLines: 5,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),

                    Center(
                      child: _isTranscribing
                          ? const Column(
                              children: [
                                CircularProgressIndicator(color: Color(0xFF2ECDA7)),
                                SizedBox(height: 8),
                                Text('Transcribing…',
                                    style: TextStyle(color: Colors.white54, fontSize: 13)),
                              ],
                            )
                          : GestureDetector(
                              onTap: _recorderReady ? _toggleRecording : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: !_recorderReady
                                      ? Colors.grey
                                      : _isRecording
                                          ? const Color(0xFFEF4444)
                                          : const Color(0xFF1D9E75),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (!_recorderReady
                                              ? Colors.grey
                                              : _isRecording
                                                  ? const Color(0xFFEF4444)
                                                  : const Color(0xFF1D9E75))
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        !_recorderReady
                            ? 'Waiting for mic permission...'
                            : _isRecording
                                ? 'Tap to stop recording'
                                : 'Tap to record symptoms via voice',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D9E75),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text('Submit Patient',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _label(String text) => Text(text,
      style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 13,
          fontWeight: FontWeight.w500));

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.07),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _dropdownCard<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF1A2E26),
        style: const TextStyle(color: Colors.white, fontSize: 15),
        iconEnabledColor: Colors.white54,
      ),
    );
  }
}