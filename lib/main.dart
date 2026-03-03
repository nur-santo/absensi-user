import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/absen_page.dart';
import 'pages/history_perizinan_page.dart';
import 'pages/perizinan_create_page.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'face/face_capture_page.dart';
import 'pages/history_kehadiran_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ENTRY POINT APP
      initialRoute: '/',

      routes: {
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/face-capture': (_) => const FaceCapturePage(),
        '/absen': (_) => const AbsenPage(),
        '/perizinan': (_) => const PerizinanPage(),
        '/perizinan/create': (_) => const PerizinanCreatePage(),
        '/kehadiran': (_) => const HistoryKehadiranPage(),
      },
    );
  }
}
