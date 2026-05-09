import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  Future<void> init() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web is not configured for Firebase in this assessment. Run on Android after adding google-services.json.',
      );
    }
    await Firebase.initializeApp();
  }
}
