import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/app.dart';
import 'package:remembeer/firebase_options.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/seed_data/seeder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  IoCContainer.initialize();

  if (kDebugMode) {
    await seedDatabase();
  }

  runApp(App());
}
