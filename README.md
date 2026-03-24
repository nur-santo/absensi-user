# App Absensi

# Aplikasi Absensi Karyawan

Aplikasi client untuk sistem absensi karyawan yang terhubung dengan backend API.  
Digunakan oleh karyawan untuk melakukan absensi, pengajuan izin, dan melihat riwayat.

---

## Deskripsi

Aplikasi ini memungkinkan karyawan untuk:

- Melakukan absensi dengan wajah atau foto
- Mengajukan izin / cuti
- Melihat riwayat absensi
- Melihat status pengajuan izin

---

## Tampilah Utama

![home](img/home.jpg)

---

## Fitur Utama

### Login

- Login menggunakan akun yang terdaftar

---

### Absensi

- Absen masuk menggunakan:
  - Face capture (kamera)
  - Foto manual
- Validasi wajah ke server
- Deteksi:
  - Keterlambatan
  - Shift
  - Mode kerja (WFO/WFH)

---

### Perizinan

- Pengajuan:
  - Izin
  - Sakit
  - Cuti
- Input tanggal & keterangan
- Upload bukti (opsional)

#### Tampilan Perizinan

![Perizinan](img/buat_perizinan.jpg)

---

### History Absensi

- List riwayat absensi harian
- Informasi:
  - Tanggal
  - Status
  - Jam masuk
  - Keterlambatan

#### Tampilan History Absensi

![History Absensi](img/kehadiran.jpg)

---

### History Perizinan

- Riwayat pengajuan izin
- Status:
  - Pending
  - Disetujui
  - Ditolak

#### Tampilan History Perizinan

![History Perizinan](img/perizinan.jpg)

---

## Teknologi

- Flutter
- REST API
- Camera Integration
- Face Recognition API

---

## Alur Sistem

1. User login
2. User melakukan absensi (face/photo)
3. Data dikirim ke backend
4. Backend validasi wajah
5. Data absensi disimpan
6. User dapat melihat riwayat

---

## Kelebihan Sistem

- Absensi lebih akurat (face recognition)
- Mendukung WFO & WFH
- Monitoring real-time oleh admin
- Terintegrasi API

---

## Catatan

- Membutuhkan koneksi internet
- Kamera diperlukan untuk fitur face recognition
