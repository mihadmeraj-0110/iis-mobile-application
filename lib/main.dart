import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/firebase_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Android and iOS use their platform configuration files. Web users should
    // initialize with generated FlutterFire options before enabling Firebase.
    await Firebase.initializeApp();
    firebaseIsReady = true;
  } on FirebaseException catch (error) {
    debugPrint('Firebase is not configured yet: ${error.code}');
  } catch (error) {
    debugPrint('Firebase is not configured yet: $error');
  }

  runApp(const ProviderScope(child: IISApp()));
}
