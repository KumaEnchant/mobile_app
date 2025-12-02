import 'package:flutter/material.dart';

const Map<String, dynamic> _sampleLatestNews = {
  "judul": "Pembaruan Aplikasi Mobile 2.0: Fitur Notifikasi Real-Time",
  "createdAt": "2023-12-01 10:30:00",
  "isi":
      "Kami dengan bangga mengumumkan peluncuran versi terbaru aplikasi mobile kami, versi 2.0! Pembaruan ini membawa peningkatan besar dalam pengalaman pengguna...",
};

class DetailBeritaPages extends StatelessWidget {
  final Map<String, dynamic> berita;

  const DetailBeritaPages({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    
    final displayData = berita.isNotEmpty ? Map<String, dynamic>.from(berita) : Map<String, dynamic>.from(_sampleLatestNews);

    // 🔥 OVERRIDE jika berita ID = 1
    if (displayData["id"] == 1) {
      displayData["judul"] = "Pembaruan Sistem Akademik Semester Ganjil 2025/2026";

      displayData["isi"] = """
SIKAD Mobile kini telah diperbarui untuk semester 5 – Ganjil 2025/2026.

Pembaruan penting:
1. Sinkronisasi jadwal perkuliahan otomatis
2. Notifikasi real-time untuk pengumuman & kehadiran
3. Peningkatan performa halaman dashboard
4. Penambahan fitur cetak KRS langsung dari aplikasi

Terima kasih atas dukungan Anda.
""";
    }

    final judul = displayData["judul"] ?? "Judul Tidak Ditemukan";
    final tanggal = displayData["createdAt"] ?? "-";
    final isi = displayData["isi"] ?? "Tidak ada isi berita yang ditemukan.";

    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(judul, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Tanggal: $tanggal", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const Divider(height: 25),
            Text(isi, style: const TextStyle(fontSize: 16, height: 1.5), textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
