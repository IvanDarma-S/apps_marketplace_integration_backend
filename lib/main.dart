import 'package:apps_marketplace_integration_backend/features/auth/presentation/providers/auth_provider.dart';
import 'package:apps_marketplace_integration_backend/features/auth/presentation/pages/login_page.dart'; // Import halaman login kamu
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

// --- TAMBAHKAN CLASS INI ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // Arahkan ke LoginPage yang baru saja kita buat
    );
  }
}
