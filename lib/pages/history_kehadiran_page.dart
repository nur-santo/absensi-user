import 'package:flutter/material.dart';
import '../services/kehadiran_service.dart';
import '../models/kehadiran_model.dart';

class HistoryKehadiranPage extends StatefulWidget {
  const HistoryKehadiranPage({super.key});

  @override
  State<HistoryKehadiranPage> createState() => _HistoryKehadiranPageState();
}

class _HistoryKehadiranPageState extends State<HistoryKehadiranPage> {
  late Future<List<Kehadiran>> _future;
  int _bulan = DateTime.now().month;
  int _tahun = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<List<Kehadiran>> _fetchData() async {
    final res = await KehadiranService.getHistory(bulan: _bulan, tahun: _tahun);
    final List list = res['data']['data'];
    return list.map((e) => Kehadiran.fromJson(e)).toList();
  }

  void _changeMonth(int delta) {
    setState(() {
      _bulan += delta;
      if (_bulan > 12) {
        _bulan = 1;
        _tahun++;
      }
      if (_bulan < 1) {
        _bulan = 12;
        _tahun--;
      }
      _future = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Riwayat Kehadiran'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F1117),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE5E7EB), height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── Month selector ──────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                  color: const Color(0xFF6B7280),
                  splashRadius: 20,
                ),
                Text(
                  _namabulan(_bulan) + ' $_tahun',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1117),
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                  color: const Color(0xFF6B7280),
                  splashRadius: 20,
                ),
              ],
            ),
          ),

          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: FutureBuilder<List<Kehadiran>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ),
                  );
                }

                final data = snapshot.data!;

                if (data.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 40, color: Color(0xFFD1D5DB)),
                        SizedBox(height: 8),
                        Text(
                          'Belum ada data kehadiran',
                          style:
                              TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final k = data[index];
                    return _KehadiranCard(kehadiran: k);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _namabulan(int bulan) {
    const names = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[bulan];
  }
}

// ── Card widget ─────────────────────────────────────────────────────────────

class _KehadiranCard extends StatelessWidget {
  final Kehadiran kehadiran;
  const _KehadiranCard({required this.kehadiran});

  @override
  Widget build(BuildContext context) {
    final k = kehadiran;

    final Color statusColor;
    final Color statusBg;
    final String statusLabel;

    switch (k.status) {
      case 'HADIR':
        statusColor = const Color(0xFF059669);
        statusBg = const Color(0xFFECFDF5);
        statusLabel = 'Hadir';
        break;
      case 'ALPA':
        statusColor = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEF2F2);
        statusLabel = 'Alpa';
        break;
      case 'IZIN':
        statusColor = const Color(0xFF0284C7);
        statusBg = const Color(0xFFF0F9FF);
        statusLabel = 'Izin';
        break;
      case 'SAKIT':
        statusColor = const Color(0xFF7C3AED);
        statusBg = const Color(0xFFF5F3FF);
        statusLabel = 'Sakit';
        break;
      case 'CUTI':
        statusColor = const Color(0xFF0284C7);
        statusBg = const Color(0xFFF0F9FF);
        statusLabel = 'Cuti';
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusBg = const Color(0xFFF1F3F6);
        statusLabel = k.status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal
            Column(
              children: [
                Text(
                  k.tanggal.day.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F1117),
                    height: 1,
                  ),
                ),
                Text(
                  _namaHari(k.tanggal.weekday),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),
            Container(width: 1, height: 48, color: const Color(0xFFE5E7EB)),
            const SizedBox(width: 14),

            // Detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),

                      // Terlambat pill
                      if (k.terlambat) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            k.menitTelat != null
                                ? 'Telat ${k.menitTelat} mnt'
                                : 'Terlambat',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Row info: shift, jam masuk, mode
                  Wrap(
                    spacing: 12,
                    runSpacing: 2,
                    children: [
                      _InfoChip(
                        label: k.shift,
                        icon: Icons.schedule_outlined,
                      ),
                      _InfoChip(
                        label: k.jamMasuk != null
                            ? k.jamMasuk!.substring(0, 5)
                            : '—',
                        icon: Icons.login,
                      ),
                      if (k.modeKerja != null)
                        _InfoChip(
                          label: k.modeKerja!,
                          icon: k.modeKerja == 'WFH'
                              ? Icons.home_outlined
                              : Icons.business_outlined,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _namaHari(int weekday) {
    const days = ['', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[weekday];
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
