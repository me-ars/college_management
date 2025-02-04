import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/mes_aimat.dart';
import 'init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBqNLUFTita28e-pHv5HfjzwJRx_kLXBL8",
          appId: "1:385710333160:android:4aca25ed8c4e7559cf3d5d",
          messagingSenderId: "385710333160",
          projectId: "mes-aimat-27492"));

  runApp(const MesAimat());
}
