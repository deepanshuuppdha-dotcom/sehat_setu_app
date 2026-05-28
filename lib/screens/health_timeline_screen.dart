import 'package:flutter/material.dart';
import 'package:sehat_setu/services/api_service.dart';

class HealthTimelineScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const HealthTimelineScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<HealthTimelineScreen> createState() => _HealthTimelineScreenState();
}

class _HealthTimelineScreenState extends State<HealthTimelineScreen> {
  List<dynamic> _prescriptions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeline();
  }

  Future<void> _loadTimeline() async {
    try {
      final data = await ApiService().getPrescriptions(widget.patientId);
      if (mounted) {
        setState(() {
          _prescriptions = data ?? [];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),
      appBar: AppBar(
        title: Text('${widget.patientName}\'s History',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2ECDA7)))
          : _prescriptions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history,
                          size: 64,
                          color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text('No past visits found',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _prescriptions.length,
                  itemBuilder: (context, index) {
                    final rx = _prescriptions[index];
                    final medications = rx['medications'] as List? ?? [];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline dot and line
                          Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF1D9E75),
                                ),
                              ),
                              if (index < _prescriptions.length - 1)
                                Container(
                                  width: 2,
                                  height: 100,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.07),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 14,
                                          color: Color(0xFF2ECDA7)),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatDate(rx['created_at']?.toString()),
                                        style: const TextStyle(
                                            color: Color(0xFF2ECDA7),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    rx['diagnosis'] ?? 'No diagnosis',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (medications.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Medications:',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    ...medications.map((med) => Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.fiber_manual_record,
                                                  size: 8,
                                                  color: Color(0xFF1D9E75)),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  med.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                  if (rx['notes'] != null &&
                                      rx['notes'].toString().isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Notes: ${rx['notes']}',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                  if (rx['follow_up_days'] != null) ...[
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1D9E75)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Follow-up in ${rx['follow_up_days']} days',
                                        style: const TextStyle(
                                            color: Color(0xFF2ECDA7),
                                            fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}