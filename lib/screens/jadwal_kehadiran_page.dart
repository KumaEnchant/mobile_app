import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import 'pertemuan_popup.dart';

class JadwalKehadiranPage extends StatefulWidget {
  const JadwalKehadiranPage({super.key});

  @override
  State<JadwalKehadiranPage> createState() => _JadwalKehadiranPageState();
}

class _JadwalKehadiranPageState extends State<JadwalKehadiranPage> {
  List<Map<String, dynamic>> daftarMatakuliah = [];
  bool isLoading = true;
  String? errorMessage;

  // Warna untuk setiap mata kuliah
  final List<int> colors = [
    0xFF2196F3,
    0xFF4CAF50,
    0xFF9C27B0,
    0xFFFF9800,
    0xFFF44336,
    0xFF00BCD4,
    0xFF673AB7,
    0xFFE91E63,
    0xFF607D8B,
  ];

  @override
  void initState() {
    super.initState();
    _loadMatakuliahFromKRS();
  }

  /// Load mata kuliah dari KRS yang sudah diambil mahasiswa (Semester 5)
  Future<void> _loadMatakuliahFromKRS() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('auth_email');

      if (token == null) {
        throw Exception("Token tidak ditemukan");
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      // 1. Get user data (NIM)
      print("--- GET USER DATA ---");
      final userRes = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );

      final userData = userRes.data['data'];
      final nim = userData['nim'];

      print("NIM Mahasiswa: $nim");

      // 2. Get daftar KRS mahasiswa
      print("--- GET DAFTAR KRS ---");
      final krsRes = await dio.get(
        "${ApiService.baseUrl}krs/daftar-krs",
        queryParameters: {"id_mahasiswa": nim},
      );

      List allKrs = krsRes.data['data'] ?? [];

      // 3. Cari KRS Semester 5 (yang aktif)
      var activeSemester = allKrs.firstWhere(
        (krs) => krs['semester'].toString() == '5',
        orElse: () => null,
      );

      if (activeSemester == null) {
        throw Exception("KRS Semester 5 belum dibuat. Silakan ambil KRS terlebih dahulu.");
      }

      int activeKrsId = activeSemester['id'];
      print("KRS Semester 5 ID: $activeKrsId");

      // 4. Get detail KRS (mata kuliah yang diambil)
      print("--- GET DETAIL KRS ---");
      final detailRes = await dio.get(
        "${ApiService.baseUrl}krs/detail-krs",
        queryParameters: {"id_krs": activeKrsId},
      );

      List selectedCourses = detailRes.data['data'] ?? [];
      print("Mata kuliah diambil: ${selectedCourses.length}");

      if (selectedCourses.isEmpty) {
        throw Exception("Belum ada mata kuliah yang diambil di Semester 5");
      }

      // 5. Transform data untuk UI
      List<Map<String, dynamic>> transformed = [];
      for (int i = 0; i < selectedCourses.length; i++) {
        var mk = selectedCourses[i];
        
        transformed.add({
          'id_krs_detail': mk['id'], // ⚠️ PENTING: ID detail KRS untuk absensi
          'kode_matkul': mk['kode_matakuliah'] ?? mk['kode'] ?? 'MK${i + 1}',
          'nama_matkul': mk['nama_matakuliah'] ?? mk['nama'] ?? 'Mata Kuliah',
          'dosen': mk['dosen'] ?? mk['nama_dosen'] ?? 'Dosen Pengampu',
          'sks': mk['jumlah_sks'] ?? mk['sks'] ?? 3,
          'hari': mk['nama_hari'] ?? mk['hari'] ?? 'Senin',
          'jam': mk['jam_mulai'] != null 
              ? '${mk['jam_mulai']} - ${mk['jam_selesai'] ?? ''}' 
              : '08:00 - 10:00',
          'ruangan': mk['ruangan'] ?? mk['nama_ruangan'] ?? 'Ruang 101',
          'color': colors[i % colors.length],
        });
      }

      setState(() {
        daftarMatakuliah = transformed;
        isLoading = false;
      });

      print("✅ Data mata kuliah berhasil dimuat: ${daftarMatakuliah.length} item");

    } catch (e) {
      print("❌ ERROR LOAD MATAKULIAH: $e");
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
        
        // Fallback ke dummy data kalau error
        daftarMatakuliah = _getDummyData();
      });
    }
  }

  /// Dummy data untuk fallback (kalau API error)
  List<Map<String, dynamic>> _getDummyData() {
    return [
      {
        'id_krs_detail': 1,
        'kode_matkul': 'WRG201',
        'nama_matkul': 'Kewarganegaraan',
        'dosen': 'Lizki Riyanda, S.Pd, M.Si',
        'sks': 2,
        'hari': 'Senin',
        'jam': '08:00 - 09:40',
        'ruangan': 'A.201',
        'color': 0xFF2196F3,
      },
      {
        'id_krs_detail': 2,
        'kode_matkul': 'PNC301',
        'nama_matkul': 'Pancasila',
        'dosen': 'Syah Firdaus Palumpun, M.Si',
        'sks': 2,
        'hari': 'Selasa',
        'jam': '10:00 - 11:40',
        'ruangan': 'B.102',
        'color': 0xFF4CAF50,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Jadwal & Kehadiran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh, color: Color(0xFF1976D2)),
                        onPressed: _loadMatakuliahFromKRS,
                      ),
                    ),
                  ],
                ),
              ),

              // Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Klik mata kuliah untuk melihat 14 pertemuan dan mulai absen',
                          style: TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // List Mata Kuliah
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Memuat mata kuliah dari KRS...'),
                            ],
                          ),
                        )
                      : errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error_outline,
                                        size: 64, color: Colors.red[300]),
                                    SizedBox(height: 16),
                                    Text(
                                      'Gagal Memuat Data',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: _loadMatakuliahFromKRS,
                                      icon: Icon(Icons.refresh),
                                      label: Text('Coba Lagi'),
                                    ),
                                    SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          errorMessage = null;
                                        });
                                      },
                                      child: Text('Gunakan Data Dummy'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : daftarMatakuliah.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.school,
                                          size: 64, color: Colors.grey[400]),
                                      SizedBox(height: 16),
                                      Text(
                                        'Belum ada mata kuliah',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Silakan ambil KRS terlebih dahulu',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(20),
                                  itemCount: daftarMatakuliah.length,
                                  itemBuilder: (context, index) {
                                    final matkul = daftarMatakuliah[index];
                                    return _buildMatkulCard(matkul);
                                  },
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatkulCard(Map<String, dynamic> matkul) {
    final color = Color(matkul['color']);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showPertemuanDialog(matkul);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Color indicator
                Container(
                  width: 5,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          matkul['kode_matkul'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        matkul['nama_matkul'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        matkul['dosen'],
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            '${matkul['hari']} • ${matkul['jam']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPertemuanDialog(Map<String, dynamic> matkul) {
    showDialog(
      context: context,
      builder: (context) => PertemuanPopup(
        idKrsDetail: matkul['id_krs_detail'],
        namaMatkul: matkul['nama_matkul'],
        kodeMatkul: matkul['kode_matkul'],
        dosen: matkul['dosen'],
        color: Color(matkul['color']),
      ),
    );
  }
}