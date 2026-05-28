import 'package:flutter/material.dart';
import 'package:sehat_setu/services/api_service.dart';
import 'package:sehat_setu/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _phoneCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _phoneCtrl.text.trim();
    final pin = _pinCtrl.text.trim();
    if (phone.isEmpty || pin.length != 4) {
      setState(() => _error = 'Enter valid phone & 4-digit PIN');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await ApiService().login(phone, pin);

    if (!mounted) return;

    if (result != null) {
      final workerId =
          result['asha_worker_id']?.toString() ?? result['id']?.toString() ?? phone;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(ashaWorkerId: workerId, workerName: result['name']?.toString()),
        ),
      );
    } else {
      setState(() {
        _loading = false;
        _error = 'Login failed — check credentials or network';
      });
    }
  }

  // Skip login for offline-first demo
  void _skipLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(ashaWorkerId: 'demo_worker', workerName: 'Demo ASHA'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F4C35), Color(0xFF1D9E75), Color(0xFF2ECDA7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ---------- Logo ----------
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.local_hospital_rounded,
                          size: 48, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text('SehatSetu',
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 6),
                    Text('ASHA Worker Login',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 40),

                    // ---------- Card ----------
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        children: [
                          _field(
                            controller: _phoneCtrl,
                            icon: Icons.phone_android_rounded,
                            hint: 'Phone Number',
                            keyboard: TextInputType.phone,
                          ),
                          const SizedBox(height: 18),
                          _field(
                            controller: _pinCtrl,
                            icon: Icons.lock_outline_rounded,
                            hint: '4-Digit PIN',
                            keyboard: TextInputType.number,
                            obscure: true,
                            maxLen: 4,
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: 14),
                            Text(_error!,
                                style: const TextStyle(
                                    color: Color(0xFFFF6B6B), fontSize: 13)),
                          ],
                          const SizedBox(height: 26),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0F4C35),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5))
                                  : const Text('Login',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Skip for demo
                          TextButton(
                            onPressed: _skipLogin,
                            child: Text('Skip (Demo Mode)',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboard,
    bool obscure = false,
    int? maxLen,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      maxLength: maxLen,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        counterText: '',
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
