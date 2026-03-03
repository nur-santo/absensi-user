import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/wajah_service.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkFlow();
  }

  Future<void> checkFlow() async {
    final user = await AuthService.getMe();

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final hasWajah = await WajahService.hasWajah();

    if (hasWajah) {
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => HomePage(user: user),
  ),
);

    } else {
      Navigator.pushReplacementNamed(context, '/face-capture');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
