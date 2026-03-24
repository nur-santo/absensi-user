import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool showPassword = false;
  bool loading = false;
  String? error;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // ================= LOGIN =================
  Future<void> submit() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      setState(() => error = "Email dan password wajib diisi");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

  final success = await AuthService.login(
  emailCtrl.text.trim(),
  passCtrl.text.trim(),
);

if (!mounted) return;

setState(() => loading = false);

if (!success) {
  setState(() => error = "Login gagal");
  return;
}

    Navigator.pushReplacementNamed(context, '/');
  }

  // ================= RESET PASSWORD =================
  Future<void> resetPassword() async {
    // ================= STEP 1: INPUT EMAIL =================
    final email = await showDialog<String>(
      context: context,
      builder: (context) {
        final ctrl = TextEditingController(text: emailCtrl.text);
  
        return AlertDialog(
          title: const Text("Lupa Password"),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Masukkan email kamu",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text("Kirim OTP"),
            ),
          ],
        );
      },
    );
  
    if (email == null || email.isEmpty) return;
  
    setState(() => loading = true);
  
    final sent = await AuthService.requestOtp(email);
  
    if (!mounted) return;
  
    setState(() => loading = false);
  
    if (!sent) {
      setState(() => error = "Gagal mengirim OTP");
      print(error);
      return;
    }
  
    // ================= STEP 2: INPUT OTP =================
    final otp = await showDialog<String>(
      context: context,
      builder: (context) {
        final ctrl = TextEditingController();
  
        return AlertDialog(
          title: const Text("Masukkan OTP"),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "OTP dari email",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text("Verifikasi"),
            ),
          ],
        );
      },
    );
  
    if (otp == null || otp.isEmpty) return;
  
    setState(() => loading = true);
  
    final valid = await AuthService.verifyOtp(email, otp);
  
    if (!mounted) return;
  
    setState(() => loading = false);
  
    if (!valid) {
      setState(() => error = "OTP salah atau expired");
      return;
    }
  
    // ================= STEP 3: INPUT PASSWORD BARU =================
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final passCtrl = TextEditingController();
        final confirmCtrl = TextEditingController();
  
        return AlertDialog(
          title: const Text("Password Baru"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password baru",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "password": passCtrl.text.trim(),
                  "confirm": confirmCtrl.text.trim(),
                });
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  
    if (result == null) return;
  
    setState(() => loading = true);
  
    final success = await AuthService.resetPasswordWithOtp(
      email: email,
      otp: otp,
      password: result["password"]!,
      passwordConfirmation: result["confirm"]!,
    );
  
    if (!mounted) return;
  
    setState(() => loading = false);
  
    if (!success) {
      setState(() => error = "Gagal reset password");
      return;
    }
  
    // ================= SUCCESS =================
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Password berhasil diubah. Silakan login."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Absensi App',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passCtrl,
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: loading ? null : resetPassword,
                child: const Text('Lupa Password?'),
              ),
            ),

            const SizedBox(height: 24),

            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}