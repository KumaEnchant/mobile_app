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

  // --- STATE DATA API ---
  Map<String, dynamic>? user;
  List<dynamic> beritaAkademik = [];
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Fungsi untuk refresh semua data (Profil & Berita)
  Future<void> _loadAllData() async {
    // Set loading true jika perlu, tapi untuk UX yang smooth saat update profil,
    // kita bisa biarkan loading background atau set state
    if (mounted) setState(() => _isLoadingData = true);
    
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
    // Mengambil nama/email default jika API belum load
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = user?['nama']?.toString() ?? arguments?['name']?.toString() ?? 'Mahasiswa';
    final email = user?['email']?.toString() ?? arguments?['email']?.toString() ?? 'email@student.swu.ac.id';

    // List Pages
    final List<Widget> pages = [
      HomeContent(
        name: name,
        email: email,
        user: user,
        beritaAkademik: beritaAkademik,
        isLoadingData: _isLoadingData,
      ),
      const ScheduleContent(),
      const GradesContent(),
      // Mengirim callback onProfileUpdated agar Dashboard bisa refresh data API
      ProfileContent(
        name: name,
        email: email,
        user: user,
        onProfileUpdated: _loadAllData, 
      ),
    ];

    return Scaffold(
      body: _isLoadingData && user == null 
          ? const Center(child: CircularProgressIndicator()) 
          : pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
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
          selectedItemColor: const Color(0xFF1976D2),
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

// ================= HOME CONTENT =================
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
      decoration: const BoxDecoration(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang,',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1976D2)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Tidak ada notifikasi baru"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Card Semester
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school, color: Color(0xFF1976D2), size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Akademik',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Semester 5 - Aktif',
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

            // Content Body
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menu Utama',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: [
                          _buildMenuCard(context, icon: Icons.info_outline, title: 'Informasi', color: const Color(0xFF2196F3), route: "/information"),
                          _buildMenuCard(context, icon: Icons.edit_note, title: 'KRS', color: const Color(0xFF4CAF50), route: "/krs"),
                          _buildMenuCard(context, icon: Icons.calendar_month, title: 'Jadwal', color: const Color(0xFF9C27B0), route: "/jadwal"),
                          _buildMenuCard(context, icon: Icons.assessment, title: 'KHS', color: const Color(0xFFF44336), route: "/khs"), // Argument user handled inside onTap if needed
                          _buildMenuCard(context, icon: Icons.check_circle, title: 'Kehadiran', color: const Color(0xFFFF9800), route: "/kehadiran"),
                          _buildMenuCard(context, icon: Icons.schedule, title: 'Jadwal Ujian', color: const Color(0xFF3F51B5), route: "/jadwal-ujian"),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Pengumuman Terbaru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      isLoadingData
                          ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                          : beritaAkademik.isEmpty
                              ? Center(child: Text("Tidak ada berita terbaru", style: TextStyle(color: Colors.grey[600])))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: beritaAkademik.length,
                                  itemBuilder: (context, index) {
                                    final berita = beritaAkademik[index];
                                    return _buildAnnouncementCard(context, berita: berita);
                                  },
                                ),
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
    required String route,
  }) {
    return InkWell(
      onTap: () {
        // Jika route KHS, kirim data user
        if (route == "/khs") {
             Navigator.pushNamed(context, route, arguments: user);
        } else {
            try {
              Navigator.pushNamed(context, route);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Fitur $title dalam pengembangan"), behavior: SnackBarBehavior.floating),
              );
            }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, {required Map<String, dynamic> berita}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailBeritaPages(berita: berita)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF2196F3).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.campaign, color: Color(0xFF1976D2), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        berita['judul'] ?? "Tanpa Judul",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        berita['createdAt'] ?? "-",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              (berita['isi'] ?? '').toString().length > 120
                  ? berita['isi'].toString().substring(0, 120) + '...'
                  : berita['isi'] ?? 'Klik untuk membaca selengkapnya...',
              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SCHEDULE CONTENT =================
class ScheduleContent extends StatelessWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data statis jadwal (bisa diganti API nanti)
    final List<Map<String, dynamic>> schedules = [
      {
        'day': 'Senin',
        'courses': [
          {'name': 'Kewarganegaraan', 'time': '08:30 - 09:30', 'room': 'Ruang 2.1', 'lecturer': 'Lutvi Riyandari,S.Pd,M.Si'},
          {'name': 'Manajemen Bisnis', 'time': '10:30 - 11:30', 'room': 'Ruang 2.2', 'lecturer': 'Novita Setianti,S.E,M.Ak,Ak.CA'},
        ],
      },
      {
        'day': 'Rabu',
        'courses': [
          {'name': 'Mobile Programing', 'time': '08:00 - 10:00', 'room': 'Lab 1', 'lecturer': 'Muhamad Aziz Setia L.,M.Kom'},
        ],
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)]),
      ),
      child: SafeArea(
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jadwal Kuliah', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                   Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today, color: Color(0xFF1976D2)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(schedule['day'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        ...List.generate(schedule['courses'].length, (i) => _buildScheduleCard(schedule['courses'][i])),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(width: 4, height: 60, color: const Color(0xFF2196F3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("${course['time']} | ${course['room']}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
                Text(course['lecturer'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= GRADES CONTENT =================
class GradesContent extends StatelessWidget {
  const GradesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)]),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Nilai Akademik', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: const Center(child: Text("Fitur Nilai akan segera hadir")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PROFILE CONTENT (UPDATED STATEFUL) =================
class ProfileContent extends StatefulWidget {
  final String name;
  final String email;
  final Map<String, dynamic>? user;
  final VoidCallback onProfileUpdated; // Callback untuk refresh API

  const ProfileContent({
    Key? key,
    required this.name,
    required this.email,
    this.user,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  // Data lokal (diisi dari SharedPreferences)
  Map<String, String> _localProfileData = {};

  @override
  void initState() {
    super.initState();
    _loadLocalProfileData();
  }

  // Load data tambahan yang disimpan lokal
  Future<void> _loadLocalProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _localProfileData = {
        'phone': prefs.getString('phone') ?? '',
        'address': prefs.getString('address') ?? '',
        'birthDate': prefs.getString('birthDate') ?? '',
        'birthPlace': prefs.getString('birthPlace') ?? '',
        'gender': prefs.getString('gender') ?? '',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    // Prioritas: API -> Fallback Widget Data -> Default
    final String displayName = widget.user?['nama']?.toString() ?? widget.name;
    final String displayEmail = widget.user?['email']?.toString() ?? widget.email;
    final String displayNim = widget.user?['nim']?.toString() ?? '-';
    final String displayProdi = widget.user?['program_studi']?['nama_prodi']?.toString() ?? '-';
    final String displayAngkatan = widget.user?['angkatan']?.toString() ?? '-';
    final String? photoUrl = widget.user?['foto']?.toString();

    // Data dari local storage
    final String phone = _localProfileData['phone']?.isNotEmpty == true ? _localProfileData['phone']! : "-";
    final String address = _localProfileData['address']?.isNotEmpty == true ? _localProfileData['address']! : "-";
    final String birthDate = _localProfileData['birthDate']?.isNotEmpty == true ? _localProfileData['birthDate']! : "-";
    final String birthPlace = _localProfileData['birthPlace']?.isNotEmpty == true ? _localProfileData['birthPlace']! : "-";
    final String gender = _localProfileData['gender']?.isNotEmpty == true ? _localProfileData['gender']! : "-";

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header Profile
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: photoUrl != null 
                          ? NetworkImage(photoUrl) 
                          : null,
                      child: photoUrl == null 
                          ? const Icon(Icons.person, size: 50, color: Color(0xFF1976D2)) 
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informasi Akademik (Dari API)
                      const Text(
                        'Informasi Akademik',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(icon: Icons.badge, title: 'NIM', value: displayNim, color: const Color(0xFF607D8B)),
                      const SizedBox(height: 12),
                      _buildInfoCard(icon: Icons.school, title: 'Program Studi', value: displayProdi, color: const Color(0xFF2196F3)),
                      const SizedBox(height: 12),
                      _buildInfoCard(icon: Icons.calendar_today, title: 'Angkatan', value: displayAngkatan, color: const Color(0xFF4CAF50)),

                      // Informasi Pribadi (Dari Local Storage)
                      const SizedBox(height: 24),
                      const Text(
                        'Informasi Pribadi',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(icon: Icons.phone, title: 'No. Telepon', value: phone, color: const Color(0xFFFF9800)),
                      const SizedBox(height: 12),
                      _buildInfoCard(icon: Icons.wc, title: 'Jenis Kelamin', value: gender, color: const Color(0xFF9C27B0)),
                      const SizedBox(height: 12),
                      _buildInfoCard(icon: Icons.location_on, title: 'Tempat Lahir', value: birthPlace, color: const Color(0xFFF44336)),
                      const SizedBox(height: 12),
                      _buildInfoCard(icon: Icons.cake, title: 'Tanggal Lahir', value: birthDate, color: const Color(0xFF3F51B5)),
                      const SizedBox(height: 12),
                      _buildInfoCard(icon: Icons.home, title: 'Alamat', value: address, color: const Color(0xFF009688)),

                      // Menu Actions
                      const SizedBox(height: 24),
                      const Text(
                        'Menu Profil',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      _buildMenuTile(
                        context,
                        icon: Icons.person_outline,
                        title: 'Edit Profil',
                        onTap: () async {
                          // Navigasi ke Edit Profil
                          // Mengirim data nama & email saat ini sebagai argumen
                          final result = await Navigator.pushNamed(
                            context,
                            '/edit-profile',
                            arguments: {'name': displayName, 'email': displayEmail},
                          );

                          // Jika kembali dengan result true (berhasil simpan)
                          if (result == true) {
                            await _loadLocalProfileData(); // Reload data lokal (HP, Alamat)
                            widget.onProfileUpdated(); // Panggil fungsi dashboard untuk reload API (Nama, Email)
                          }
                        },
                      ),
                      _buildMenuTile(
                        context,
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        onTap: () => Navigator.pushNamed(context, '/change-password'),
                      ),
                      _buildMenuTile(
                        context,
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Text('Tentang'),
                              content: Text('E-Campus App v1.0.0'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
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
                                Navigator.pop(context); // Tutup alert
                                await ApiService.logout(); // Hapus token
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
                            backgroundColor: Colors.red[50],
                            foregroundColor: Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text('Keluar Aplikasi'),
                        ),
                      ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF2196F3).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: const Color(0xFF1976D2), size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}