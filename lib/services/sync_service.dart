import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:sehat_setu/db/database.dart';
import 'package:sehat_setu/services/api_service.dart';

/// Watches connectivity and auto-syncs unsynced patients when back online.
class SyncService extends ChangeNotifier {
  final AppDatabase _db;
  final ApiService _api;
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _isOnline = true;
  bool _isSyncing = false;

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;

  SyncService(this._db, this._api) {
    _bootstrap();
  }

  void _bootstrap() {
    Connectivity().checkConnectivity().then((results) {
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      notifyListeners();
      if (_isOnline) syncNow();
    });

    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      notifyListeners();
      if (wasOffline && _isOnline) syncNow();
    });
  }

  /// Push every unsynced patient to the backend.
  Future<void> syncNow() async {
    if (_isSyncing || !_isOnline) return;
    _isSyncing = true;
    notifyListeners();

    try {
      final queue = await _db.getUnsyncedPatients();
      if (queue.isEmpty) {
        _isSyncing = false;
        notifyListeners();
        return;
      }

      // Try bulk sync first
      final results = await _api.syncOfflineQueue(queue);

      if (results.isNotEmpty) {
        for (final r in results) {
          await _db.markAsSynced(
            r.localId,
            serverId: r.id,
            urgencyScore: r.urgencyScore,
            aiSummary: r.aiSummary,
          );
        }
      } else {
        // Fallback: sync one-by-one
        for (final p in queue) {
          final r = await _api.submitPatient(p);
          if (r != null) {
            await _db.markAsSynced(
              p.localId,
              serverId: r.id,
              urgencyScore: r.urgencyScore,
              aiSummary: r.aiSummary,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('SyncService error: $e');
    }

    _isSyncing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
