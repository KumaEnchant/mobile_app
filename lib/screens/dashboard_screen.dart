import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../api/api_service.dart';
import 'package:quickalert/quickalert.dart';
import './detail_berita_pages.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // --- VARIABEL API (DITAMBAHKAN) ---
  Map<String, dynamic>? user;
  List<dynamic> beritaAkademik = [];
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi API saat pertama kali dibuka
    _loadAllData();
  }

  // --- FUNGSI API (DITAMBAHKAN) ---
  Future<void> _loadAllData() async {
    await Future.wait([
      _getMahasiswaData(),
      _getBeritaAkademik(),
    ]);
    if (mounted) {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  Future<void> _getMahasiswaData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");
      final email = prefs.getString("auth_email");

      if (token == null || email == null) return;

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-type'] = 'application/json';

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        if (mounted) {
          setState(() {
            user = response.data["data"];
          });
        }
      }
    } catch (e) {
      debugPrint("Error getMahasiswa: $e");
    }
  }

  Future<void> _getBeritaAkademik() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) return;

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-type'] = 'application/json';

      final response = await dio.get("${ApiService.baseUrl}info/berita");

      if (response.statusCode == 200 && response.data['data'] != null) {
        if (mounted) {
          setState(() {
            beritaAkademik = response.data["data"];
          });
        }
      }
    } catch (e) {
      debugPrint("Error getBerita: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan data dari arguments atau dari API
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = user?['nama']?.toString() ?? arguments?['name']?.toString() ?? 'Mahasiswa';
    final email = user?['email']?.toString() ?? arguments?['email']?.toString() ?? 'email@student.swu.ac.id';

    final List<Widget> _pages = [
      HomeContent(
        name: name,
        email: email,
        user: user,
        beritaAkademik: beritaAkademik,
        isLoadingData: _isLoadingData,
      ),
      ScheduleContent(),
      GradesContent(),
      ProfileContent(name: name, email: email, user: user),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF1976D2),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grade_outlined),
              activeIcon: Icon(Icons.grade),
              label: 'Nilai',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// HOME CONTENT (DIMODIFIKASI UNTUK PAKAI API)
class HomeContent extends StatelessWidget {
  final String name;
  final String email;
  final Map<String, dynamic>? user;
  final List<dynamic> beritaAkademik;
  final bool isLoadingData;

  const HomeContent({
    Key? key,
    required this.name,
    required this.email,
    this.user,
    required this.beritaAkademik,
    required this.isLoadingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            name.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.notifications_outlined, color: Color(0xFF1976D2)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Tidak ada notifikasi baru"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Info Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF2196F3).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school,
                            color: Color(0xFF1976D2),
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Semester Aktif',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Semester 5 - Ganjil 2025/2026',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu Utama',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Menu Grid
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: [
                          _buildMenuCard(
                            context,
                            icon: Icons.info_outline,
                            title: 'Informasi',
                            color: Color(0xFF2196F3),
                            onTap: () {
                              Navigator.pushNamed(context, "/information");
                            },
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.edit_note,
                            title: 'KRS',
                            color: Color(0xFF4CAF50),
                            onTap: () {
                              Navigator.pushNamed(context, "/krs");
                            },
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.calendar_month,
                            title: 'Jadwal',
                            color: Color(0xFF9C27B0),
                            onTap: () {
                              Navigator.pushNamed(context, "/jadwal");
                            },
                          ),
                          _buildMenuCard(
                          context,
                          icon: Icons.assessment,
                          title: 'KHS',
                          color: Color(0xFFF44336),
                          onTap: () {
                            // UBAH BAGIAN INI: Kirim data user sebagai arguments
                            Navigator.pushNamed(
                              context, 
                              "/khs", 
                              arguments: user // 'user' didapat dari variabel di HomeContent
                            );
                          },
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.check_circle,
                            title: 'Kehadiran',
                            color: Color(0xFFFF9800),
                            onTap: () {
                              Navigator.pushNamed(context, "/kehadiran");
                            },
                          ),
                          _buildMenuCard(
                            context,
                            icon: Icons.schedule,
                            title: 'Jadwal Ujian',
                            color: Color(0xFF3F51B5),
                            onTap: () {
                              Navigator.pushNamed(context, "/jadwal-ujian");
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Pengumuman (DIUBAH PAKAI DATA DARI API)
                      Text(
                        'Pengumuman Terbaru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Loading atau Data Berita
                      isLoadingData
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : beritaAkademik.isEmpty
                              ? _buildAnnouncementCard(
                                  title: 'Jadwal UTS Semester 5',
                                  date: '10 Oktober 2025',
                                  description: 'Pelaksanaan UTS akan dilaksanakan mulai tanggal 15-20 Oktober 2025.',
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Detail pengumuman"),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                )
                              : Column(
                                  children: beritaAkademik.take(3).map((berita) {
                                    return _buildAnnouncementCard(
                                      title: berita['judul'] ?? 'Tanpa Judul',
                                      date: berita['createdAt'] ?? '-',
                                      description: (berita['isi'] ?? '').toString().length > 120
                                      ? berita['isi'].toString().substring(0, 120) + '...'
                                      : berita['isi'] ?? 'Klik untuk membaca selengkapnya...',
                                      onTap: () {
                                        print("DATA BERITA YANG DIKIRIM:");
                                        print(berita); // ➜ Debugging untuk lihat isinya

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailBeritaPages(berita: berita),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),

                      // Tampilkan berita default jika tidak ada data API
                      if (!isLoadingData && beritaAkademik.isEmpty) ...[
                        SizedBox(height: 12),
                        _buildAnnouncementCard(
                          title: 'Pembayaran SPP',
                          date: '08 Oktober 2025',
                          description: 'Batas akhir pembayaran SPP tanggal 25 Oktober 2025.',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Detail pengumuman"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fitur $title sedang dalam pengembangan"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String date,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.campaign,
                    color: Color(0xFF1976D2),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SCHEDULE CONTENT (TIDAK DIUBAH)
class ScheduleContent extends StatelessWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> schedules = [
      {
        'day': 'Senin',
        'courses': [
          {'name': 'Kewarganegaraan', 'time': '08:30 - 09:30', 'room': 'Ruang 2.1', 'lecturer': 'Lutvi Riyandari,S.Pd,M.Si'},
          {'name': 'Pancasila', 'time': '09:00 - 10:30', 'room': 'Ruang 2.2', 'lecturer': 'Syah Firdaus Palumpun,M.Si'},
          {'name': 'Manajemen Bisnis', 'time': '10:30 - 11:30', 'room': 'Ruang 2.2', 'lecturer': 'Novita Setianti,S.E,M.Ak,Ak.CA'},
        ],
      },
      {
        'day': 'Selasa',
        'courses': [
          {'name': 'Agama', 'time': '09:00 - 10:00', 'room': 'Ruang 1.1', 'lecturer': 'Ramelan,S.Pd,M.Pd'},
          {'name': 'Technopreneurship', 'time': '10:00 - 11:00', 'room': 'Ruang 1.2', 'lecturer': 'Sunaryono,M.Kom'},
          {'name': 'Rangkaian Digital', 'time': '13:00 - 14:30', 'room': 'Ruang 2.1', 'lecturer': 'Singgih Setia A.,S.Kom'},
        ],
      },
      {
        'day': 'Rabu',
        'courses': [
          {'name': 'Mobile Programing', 'time': '08:00 - 10:00', 'room': 'Lab 1', 'lecturer': 'Muhamad Aziz Setia L.,M.Kom'},
          {'name': 'Data Mining', 'time': '10:00 - 11:30', 'room': 'Lab 1', 'lecturer': 'Siti Delima Sari,M.Kom'},
        ],
      },
      {
        'day': 'Kamis',
        'courses': [
          {'name': 'Etika Profesi & Bimbingan Karir', 'time': '13:00 - 14:00', 'room': 'Ruangan 1.3', 'lecturer': 'Riyanti Yunita K,S.Pd,M.Kom'},
          {'name': 'Bahasa Indonesia', 'time': '14:00 - 15:00', 'room': 'Ruangan 1.4', 'lecturer': 'Uki Hares Yulianti,S.Pd,M.Pd.'},
        ],
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jadwal Kuliah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Kalender akademik"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 12),
                          child: Text(
                            schedule['day'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        ...List.generate(
                          schedule['courses'].length,
                          (i) => _buildScheduleCard(schedule['courses'][i]),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> course) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      course['time'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.room, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      course['room'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        course['lecturer'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// GRADES CONTENT (TIDAK DIUBAH)
class GradesContent extends StatelessWidget {
  const GradesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> grades = [
      {'course': 'REKAYASA PERANGKAT KERAS', 'grade': 'A', 'credits': 3},
      {'course': 'ARSITEK DAN ORGANISASI KOMPUTER', 'grade': 'A', 'credits': 3},
      {'course': 'SISTEM PENUNJANG KEPUTUSAN', 'grade': 'B', 'credits': 3},
      {'course': 'SISTEM BASIS DATA LANJUT', 'grade': 'A', 'credits': 4},
      {'course': 'PEMROGRAMAN BAHASA RAKITAN', 'grade': 'A', 'credits': 4},
      {'course': 'KRIPTOGRAFI', 'grade': 'A', 'credits': 3},
      {'course': 'PEMROGRAMAN BERORIENTASI OBJEK', 'grade': 'A', 'credits': 4},
    ];

    double ipk = 3.79;
    int totalCredits = 90;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nilai Akademik',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.download, color: Color(0xFF1976D2)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Download transkrip nilai"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // IPK Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'IPK',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              ipk.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 60,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        Column(
                          children: [
                            Text(
                              'Total SKS',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              totalCredits.toString(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Text(
                        "Nilai Semester 4",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: grades.length,
                        itemBuilder: (context, index) {
                          final grade = grades[index];
                          return _buildGradeCard(grade);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(Map<String, dynamic> grade) {
    Color gradeColor;
    if (grade['grade'].startsWith('A')) {
      gradeColor = Color(0xFF4CAF50);
    } else if (grade['grade'].startsWith('B')) {
      gradeColor = Color(0xFF2196F3);
    } else if (grade['grade'].startsWith('C')) {
      gradeColor = Color(0xFFFF9800);
    } else {
      gradeColor = Color(0xFFF44336);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                grade['grade'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade['course'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${grade['credits']} SKS',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PROFILE CONTENT (DIMODIFIKASI UNTUK PAKAI DATA API)
class ProfileContent extends StatelessWidget {
  final String name;
  final String email;
  final Map<String, dynamic>? user;

  const ProfileContent({
    Key? key,
    required this.name,
    required this.email,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil data dari API atau gunakan default
    final String displayName = user?['nama']?.toString() ?? name;
    final String displayEmail = user?['email']?.toString() ?? email;
    final String displayNim = user?['nim']?.toString() ?? 'STI202303510';
    final String displayProdi = user?['program_studi']?['nama_prodi']?.toString() ?? 'Teknik Informatika';
    final String displayAngkatan = user?['angkatan']?.toString() ?? '2023';
    final String? photoUrl = user?['foto']?.toString();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF2196F3),
            Color(0xFF1976D2),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                      image: photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: photoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF1976D2),
                          )
                        : null,
                  ),
                  SizedBox(height: 16),

                  Text(
                    displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    displayEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'NIM: $displayNim',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Akademik',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      _buildInfoCard(
                        icon: Icons.school,
                        title: 'Program Studi',
                        value: displayProdi,
                        color: Color(0xFF2196F3),
                      ),
                      SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        title: 'Tahun Angkatan',
                        value: displayAngkatan,
                        color: Color(0xFF4CAF50),
                      ),
                      SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.class_,
                        title: 'Semester',
                        value: 'Semester 5',
                        color: Color(0xFFFF9800),
                      ),
                      SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.grade,
                        title: 'IPK',
                        value: '3.79',
                        color: Color(0xFF9C27B0),
                      ),
                      SizedBox(height: 24),

                      Text(
                        'Menu Profil',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      _buildMenuTile(
                        context,
                        icon: Icons.person_outline,
                        title: 'Edit Profil',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/edit-profile',
                            arguments: {
                              'name': displayName,
                              'email': displayEmail,
                            },
                          );
                        },
                      ),
                      _buildMenuTile(
                        context,
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        onTap: () {
                          Navigator.pushNamed(context, '/change-password');
                        },
                      ),
                      _buildMenuTile(
                        context,
                        icon: Icons.notifications_outlined,
                        title: 'Notifikasi',
                        onTap: () {
                          Navigator.pushNamed(context, '/notification');
                        },
                      ),
                      _buildMenuTile(
                        context,
                        icon: Icons.help_outline,
                        title: 'Bantuan',
                        onTap: () {
                          Navigator.pushNamed(context, '/help');
                        },
                      ),
                      _buildMenuTile(
                        context,
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Tentang Aplikasi'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('E-Campus STMIK Widya Utama'),
                                  SizedBox(height: 8),
                                  Text('Versi 1.0.0'),
                                  SizedBox(height: 8),
                                  Text('© 2025 STMIK Widya Utama'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),

                      // Logout Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text: 'Apakah Anda yakin ingin keluar?',
                              confirmBtnText: 'Ya',
                              cancelBtnText: 'Tidak',
                              confirmBtnColor: Colors.red,
                              onConfirmBtnTap: () async {
                                Navigator.pop(context);
                                await ApiService.logout();
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    "/login",
                                    (route) => false,
                                  );
                                }
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF44336),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.logout),
                          label: Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Color(0xFF1976D2),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}