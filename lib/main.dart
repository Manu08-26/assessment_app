import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FirebaseService().init();
    runApp(const MyApp());
  } catch (e) {
    runApp(_BootstrapErrorApp(error: e.toString()));
  }
}

class _BootstrapErrorApp extends StatelessWidget {
  final String error;

  const _BootstrapErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Setup Required')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Firebase is not configured yet. Add google-services.json (Android) and GoogleService-Info.plist (iOS) then rebuild.\n\nError: $error',
          ),
        ),
      ),
    );
  }
}
