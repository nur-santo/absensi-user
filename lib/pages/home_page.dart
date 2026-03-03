import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/storage.dart';

class HomePage extends StatelessWidget {
  final UserModel user;

  const HomePage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SecureStorage.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== USER CARD =====
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(user.email),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: [
                              _chip(user.instansi),
                              _chip(user.status),
                              _chip(user.modeKerja),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== SHIFT INFO =====
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(
                  user.shift.namaShift,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Jam Kerja: ${user.shift.mulai} - ${user.shift.selesai}',
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Menu Utama',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _featureCard(
                  context,
                  icon: Icons.fingerprint,
                  title: 'Absen',
                  route: '/absen',
                ),
                _featureCard(
                  context,
                  icon: Icons.assignment,
                  title: 'Buat Perizinan',
                  route: '/perizinan/create',
                ),
                _featureCard(
                  context,
                  icon: Icons.history,
                  title: 'History Kehadiran',
                  route: '/kehadiran',
                ),
                _featureCard(
                  context,
                  icon: Icons.history,
                  title: 'History Perizinan',
                  route: '/perizinan',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== CHIP HELPER =====
  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.blue.shade50,
      side: BorderSide(color: Colors.blue.shade200),
    );
  }

  // ===== FEATURE CARD =====
  Widget _featureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
