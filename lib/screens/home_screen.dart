import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_setu/services/sync_service.dart';
import 'package:sehat_setu/screens/patient_intake_screen.dart';
import 'package:sehat_setu/screens/patients_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final String ashaWorkerId;
  final String? workerName;

  const HomeScreen({
    super.key,
    required this.ashaWorkerId,
    this.workerName,
  });

  @override
  Widget build(BuildContext context) {
    final sync = context.watch<SyncService>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F1A17),
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Connectivity banner ----------
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: sync.isOnline
                    ? const Color(0xFF1D9E75).withOpacity(0.9)
                    : const Color(0xFFF59E0B).withOpacity(0.9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sync.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sync.isSyncing
                        ? 'Syncing offline patients…'
                        : sync.isOnline
                            ? 'Online — connected to server'
                            : 'Offline — data saved locally',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  if (sync.isSyncing) ...[
                    const SizedBox(width: 10),
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),

            // ---------- Body ----------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Text(
                      'Namaste${workerName != null ? ', $workerName' : ''} 🙏',
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'SehatSetu — AI Health Triage',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 48),

                    // Card 1 — Register
                    _ActionCard(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Register New Patient',
                      subtitle: 'Record symptoms via voice or text',
                      gradient: const [Color(0xFF1D9E75), Color(0xFF2ECDA7)],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PatientIntakeScreen(ashaWorkerId: ashaWorkerId),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card 2 — View
                    _ActionCard(
                      icon: Icons.list_alt_rounded,
                      title: 'View Submitted Patients',
                      subtitle: 'Triage list with urgency badges',
                      gradient: const [Color(0xFF0E7C5F), Color(0xFF1D9E75)],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PatientsListScreen()),
                      ),
                    ),

                    const Spacer(),

                    // Manual sync button
                    Center(
                      child: TextButton.icon(
                        onPressed: sync.isSyncing ? null : () => sync.syncNow(),
                        icon: const Icon(Icons.sync_rounded, size: 18),
                        label: const Text('Force Sync'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: gradient.first.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.75))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
