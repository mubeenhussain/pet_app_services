import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_app/app.dart';
import 'package:pet_app/bootstrap/bootstrap.dart';
import 'package:pet_app/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.init(
    flavor: AppFlavor.admin,
    useFirebaseEmulator: true,
  );

  await Bootstrap.init();
  runApp(const ProviderScope(child: PetApp()));
}
