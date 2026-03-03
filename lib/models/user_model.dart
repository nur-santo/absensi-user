class UserModel {
  final int id;
  final String name;
  final String email;
  final String instansi;
  final String status;
  final String modeKerja;
  final ShiftModel shift;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.instansi,
    required this.status,
    required this.modeKerja,
    required this.shift,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      instansi: json['instansi'],
      status: json['status'],
      modeKerja: json['mode_kerja'],
      shift: ShiftModel.fromJson(json['shift']),
    );
  }
}

class ShiftModel {
  final String namaShift;
  final String mulai;
  final String selesai;

  ShiftModel({
    required this.namaShift,
    required this.mulai,
    required this.selesai,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      namaShift: json['nama_shift'],
      mulai: json['mulai'],
      selesai: json['selesai'],
    );
  }
}
