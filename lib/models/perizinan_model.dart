class Perizinan {
  final int id;
  final String jenis;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String? keterangan;
  final String? lampiran;
  final String status;
  final String? approvedBy;
  final String createdAt;

  Perizinan({
    required this.id,
    required this.jenis,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    this.keterangan,
    this.lampiran,
    required this.status,
    this.approvedBy,
    required this.createdAt,
  });

  factory Perizinan.fromJson(Map<String, dynamic> json) {
    return Perizinan(
      id: int.tryParse(json['id'].toString()) ?? 0,
      jenis: json['jenis']?.toString() ?? '',
      tanggalMulai: json['tanggal_mulai']?.toString() ?? '',
      tanggalSelesai: json['tanggal_selesai']?.toString() ?? '',
      keterangan: json['keterangan']?.toString(),
      lampiran: json['lampiran']?.toString(),
      status: json['status']?.toString() ?? 'PENDING',
      approvedBy: json['approved_by']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
