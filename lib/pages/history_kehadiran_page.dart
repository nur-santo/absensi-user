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
  final int bulan = DateTime.now().month;
  final int tahun = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<List<Kehadiran>> fetchData() async {
    final res = await KehadiranService.getHistory(
      bulan: bulan,
      tahun: tahun,
    );

    final List list = res['data']['data'];
    return list.map((e) => Kehadiran.fromJson(e)).toList();
  }

  Color statusColor(String status) {
    switch (status) {
      case 'HADIR':
        return Colors.green;
      case 'ALPA':
        return Colors.red;
      case 'IZIN':
      case 'CUTI':
      case 'SAKIT':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Kehadiran'),
      ),
      body: FutureBuilder<List<Kehadiran>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text('Belum ada data'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final k = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(formatTanggal(k.tanggal)), 
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jam Masuk: ${k.jamMasuk ?? '-'}'),
                      Text('Mode: ${k.modeKerja ?? '-'}'), 
                      if (k.terlambat && k.keterlambatan != null)
                        Text(
                          'Terlambat: ${k.keterlambatan}',
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(k.status),
                    backgroundColor: statusColor(k.status),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}

String formatTanggal(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}-"
         "${date.month.toString().padLeft(2, '0')}-"
         "${date.year}";
}
