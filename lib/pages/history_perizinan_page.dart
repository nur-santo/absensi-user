import 'package:flutter/material.dart';
import '../../models/perizinan_model.dart';
import '../../services/perizinan_service.dart';

class PerizinanPage extends StatefulWidget {
  const PerizinanPage({super.key});

  @override
  State<PerizinanPage> createState() => _PerizinanPageState();
}

class _PerizinanPageState extends State<PerizinanPage> {
  late Future<List<Perizinan>> _future;

  @override
  void initState() {
    super.initState();
    _future = PerizinanService.getPerizinan();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'DISETUJUI':
        return Colors.green;
      case 'DITOLAK':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perizinan Saya'),
      ),
      body: FutureBuilder<List<Perizinan>>(
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
            return const Center(
              child: Text('Belum ada pengajuan perizinan'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    item.jenis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${item.tanggalMulai} → ${item.tanggalSelesai}',
                      ),
                      if (item.keterangan != null)
                        Text('Ket: ${item.keterangan}'),
                      if (item.approvedBy != null)
                        Text('Disetujui oleh: ${item.approvedBy}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      item.status,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _statusColor(item.status),
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
