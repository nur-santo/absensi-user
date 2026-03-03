import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/perizinan_service.dart';

class PerizinanCreatePage extends StatefulWidget {
  const PerizinanCreatePage({super.key});

  @override
  State<PerizinanCreatePage> createState() => _PerizinanCreatePageState();
}

class _PerizinanCreatePageState extends State<PerizinanCreatePage> {
  final ketCtrl = TextEditingController();

  String jenis = 'IZIN';
  DateTime? tglMulai;
  DateTime? tglSelesai;
  File? lampiran;
  bool loading = false;

  Future<void> pickDate(bool isMulai) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isMulai) {
          tglMulai = picked;
          if (tglSelesai != null && tglSelesai!.isBefore(picked)) {
            tglSelesai = null;
          }
        } else {
          tglSelesai = picked;
        }
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        lampiran = File(result.files.single.path!);
      });
    }
  }

  Future<void> submit() async {
    if (tglMulai == null || tglSelesai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal harus diisi')),
      );
      return;
    }

    setState(() => loading = true);

    final success = await PerizinanService.store(
      jenis: jenis,
      tanggalMulai: tglMulai!.toIso8601String().substring(0, 10),
      tanggalSelesai: tglSelesai!.toIso8601String().substring(0, 10),
      keterangan: ketCtrl.text.isEmpty ? null : ketCtrl.text,
      lampiran: lampiran,
    );

    setState(() => loading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim perizinan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Perizinan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // JENIS
            DropdownButtonFormField(
              value: jenis,
              items: const [
                DropdownMenuItem(value: 'IZIN', child: Text('Izin')),
                DropdownMenuItem(value: 'CUTI', child: Text('Cuti')),
                DropdownMenuItem(value: 'SAKIT', child: Text('Sakit')),
              ],
              onChanged: (v) => setState(() => jenis = v!),
              decoration: const InputDecoration(
                labelText: 'Jenis Perizinan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // TANGGAL MULAI
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(
                tglMulai == null
                    ? 'Pilih Tanggal Mulai'
                    : tglMulai!.toString().substring(0, 10),
              ),
              onTap: () => pickDate(true),
            ),

            // TANGGAL SELESAI
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(
                tglSelesai == null
                    ? 'Pilih Tanggal Selesai'
                    : tglSelesai!.toString().substring(0, 10),
              ),
              onTap: () => pickDate(false),
            ),

            const SizedBox(height: 16),

            // KETERANGAN
            TextField(
              controller: ketCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Keterangan (opsional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // LAMPIRAN
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: Text(
                lampiran == null
                    ? 'Upload Lampiran (jpg/png/pdf)'
                    : lampiran!.path.split('/').last,
              ),
              onTap: pickFile,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kirim Perizinan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
