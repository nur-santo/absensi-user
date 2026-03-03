class Kehadiran {
  final int id;
  final String shift;
  final String jamShiftMasuk;
  final String? jamMasuk;
  final String? modeKerja;
  final DateTime tanggal;
  final String status;
  final bool terlambat;
  final String? keterlambatan;

  Kehadiran({
    required this.id,
    required this.shift,
    required this.jamShiftMasuk,
    this.jamMasuk,
    this.modeKerja,
    required this.tanggal,
    required this.status,
    required this.terlambat,
    this.keterlambatan,
  });

  factory Kehadiran.fromJson(Map<String, dynamic> json) {
    return Kehadiran(
      id: json['id'],
      shift: json['shift'],
      jamShiftMasuk: json['jam_shift_masuk'],
      jamMasuk: json['jam_masuk'],
      modeKerja: json['mode_kerja'],
      tanggal: DateTime.parse(json['tanggal']).toLocal(),
      status: json['status'],
      terlambat: json['terlambat'] == true || json['terlambat'] == 1,
      keterlambatan: json['keterlambatan'],
    );
  }
}
