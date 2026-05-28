import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sehat_setu/db/database.dart';
import 'package:sehat_setu/services/api_service.dart';
import 'package:sehat_setu/services/sync_service.dart';
import 'package:sehat_setu/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final api = ApiService();
  final syncService = SyncService(db, api);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider<SyncService>.value(value: syncService),
      ],
      child: const SehatSetuApp(),
    ),
  );
}

class SehatSetuApp extends StatelessWidget {
  const SehatSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SehatSetu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1D9E75),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1A17),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
