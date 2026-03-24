import 'package:flutter/material.dart';
import '../services/perizinan_service.dart';
import '../models/perizinan_model.dart';

class HistoryPerizinanPage extends StatefulWidget {
  const HistoryPerizinanPage({super.key});

  @override
  State<HistoryPerizinanPage> createState() => _HistoryPerizinanPageState();
}

class _HistoryPerizinanPageState extends State<HistoryPerizinanPage> {
  late Future<List<Perizinan>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<List<Perizinan>> _fetchData() async {
    final res = await PerizinanService.getPerizinan();

    // Kalau service sudah return List<Perizinan>
    if (res is List<Perizinan>) return res;

    // Kalau service return raw List (JSON belum di-parse)
    final list = res is List<dynamic>
        ? res
        : (res as Map<String, dynamic>)['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => Perizinan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Riwayat Perizinan'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F1117),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE5E7EB), height: 1),
        ),
      ),
      body: FutureBuilder<List<Perizinan>>(
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
                    'Belum ada riwayat perizinan',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: data.length,
            itemBuilder: (context, index) =>
                _PerizinanCard(perizinan: data[index]),
          );
        },
      ),
    );
  }
}

// ── Card widget ──────────────────────────────────────────────────────────────

class _PerizinanCard extends StatelessWidget {
  final Perizinan perizinan;
  const _PerizinanCard({required this.perizinan});

  @override
  Widget build(BuildContext context) {
    final p = perizinan;

    // ── Jenis warna ──
    final Color jenisColor;
    final Color jenisBg;
    switch (p.jenis) {
      case 'SAKIT':
        jenisColor = const Color(0xFF7C3AED);
        jenisBg = const Color(0xFFF5F3FF);
        break;
      case 'CUTI':
        jenisColor = const Color(0xFF0284C7);
        jenisBg = const Color(0xFFF0F9FF);
        break;
      default: // IZIN
        jenisColor = const Color(0xFF0284C7);
        jenisBg = const Color(0xFFEFF6FF);
    }

    // ── Status warna ──
    final Color statusColor;
    final Color statusBg;
    final String statusLabel;
    switch (p.status) {
      case 'DISETUJUI':
        statusColor = const Color(0xFF059669);
        statusBg = const Color(0xFFECFDF5);
        statusLabel = 'Disetujui';
        break;
      case 'DITOLAK':
        statusColor = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEF2F2);
        statusLabel = 'Ditolak';
        break;
      default: // PENDING
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFFFBEB);
        statusLabel = 'Menunggu';
    }

    // Parse tanggal dari string yyyy-MM-dd
    final mulai = DateTime.tryParse(p.tanggalMulai);
    final selesai = DateTime.tryParse(p.tanggalSelesai);
    final sameDay = p.tanggalMulai == p.tanggalSelesai;

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
            // Tanggal mulai
            Column(
              children: [
                Text(
                  mulai != null ? mulai.day.toString().padLeft(2, '0') : '--',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F1117),
                    height: 1,
                  ),
                ),
                Text(
                  mulai != null ? _namabulan(mulai.month) : '',
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
                  // Pills: jenis + status
                  Row(
                    children: [
                      _Pill(label: p.jenis, color: jenisColor, bg: jenisBg),
                      const SizedBox(width: 6),
                      _Pill(
                          label: statusLabel, color: statusColor, bg: statusBg),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Periode
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: sameDay
                        ? _formatTanggal(mulai)
                        : '${_formatTanggal(mulai)} → ${_formatTanggal(selesai)}',
                  ),

                  // Keterangan
                  if (p.keterangan != null && p.keterangan!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    _InfoRow(
                      icon: Icons.notes_outlined,
                      label: p.keterangan!,
                      maxLines: 2,
                    ),
                  ],

                  // Lampiran
                  if (p.lampiran != null) ...[
                    const SizedBox(height: 2),
                    _InfoRow(
                      icon: Icons.attach_file,
                      label: 'Ada lampiran',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _namabulan(int bulan) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return names[bulan];
  }

  String _formatTanggal(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')} '
        '${_namabulan(date.month)} ${date.year}';
  }
}

// ── Shared widgets ───────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const _Pill({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int maxLines;
  const _InfoRow({
    required this.icon,
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }
}
