import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import 'jadwal_screen.dart';

class KRSScreen extends StatefulWidget {
  const KRSScreen({super.key});

  @override
  State<KRSScreen> createState() => _KRSScreenState();
}

class _KRSScreenState extends State<KRSScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ================= VARIABLES =================
  Map<String, dynamic>? user;
  
  // Data Lists
  List<dynamic> availableCourses = [];
  List<dynamic> selectedCourses = [];
  List<dynamic> historyKrs = []; 
  
  Map<String, bool> expandedSemesters = {};

  // Status
  bool isLoading = true;
  bool isProcessing = false;
  String errorMessage = "";

  // Config
  final int currentSemester = 5;
  final int maxSKS = 24;
  int totalSKS = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ================= LOGIC LOAD DATA (SIMULASI) =================

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      await _getUserData(); 
      await _loadCoursesManual(); // Load Matkul Smt 5 + Tambahan
      _loadHistoryManual();       // Load Riwayat Smt 1-4 Lengkap
    } catch (e) {
      print("ERROR: $e");
      setState(() => errorMessage = "Gagal memuat data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
         // Logic fetch user bisa ditaruh sini jika perlu
      }
    } catch (e) {
      print("Skip user data fetch");
    }
  }

  // ✅ DATA MANUAL SEMESTER 5 + TAMBAHAN
  Future<void> _loadCoursesManual() async {
    List<Map<String, dynamic>> manualData = [
      // === SEMESTER 5 (UTAMA) ===
      {'id': 101, 'nama_matakuliah': 'Kewarganegaraan', 'jumlah_sks': 2, 'dosen': 'Lutvi Riyandari, S.Pd., M.Si.', 'nama_hari': 'Senin', 'jam_mulai': '08:00', 'jam_selesai': '09:40'},
      {'id': 102, 'nama_matakuliah': 'Pancasila', 'jumlah_sks': 2, 'dosen': 'Syah Firdaus, M.Si.', 'nama_hari': 'Senin', 'jam_mulai': '10:00', 'jam_selesai': '11:40'},
      {'id': 103, 'nama_matakuliah': 'Manajemen Bisnis', 'jumlah_sks': 2, 'dosen': 'Novita Setianti, S.E., M.Ak.', 'nama_hari': 'Senin', 'jam_mulai': '13:00', 'jam_selesai': '14:40'},
      {'id': 104, 'nama_matakuliah': 'Agama', 'jumlah_sks': 2, 'dosen': 'Ramelan, S.Pd., M.Pd.', 'nama_hari': 'Selasa', 'jam_mulai': '08:00', 'jam_selesai': '09:40'},
      {'id': 105, 'nama_matakuliah': 'Technopreneurship', 'jumlah_sks': 2, 'dosen': 'Sunaryono, M.Kom.', 'nama_hari': 'Selasa', 'jam_mulai': '10:00', 'jam_selesai': '11:40'},
      {'id': 106, 'nama_matakuliah': 'Rangkaian Digital', 'jumlah_sks': 3, 'dosen': 'Singgih Setia A., S.Kom.', 'nama_hari': 'Selasa', 'jam_mulai': '13:00', 'jam_selesai': '15:30'},
      {'id': 107, 'nama_matakuliah': 'Mobile Programming', 'jumlah_sks': 4, 'dosen': 'M. Aziz Setia L., M.Kom.', 'nama_hari': 'Rabu', 'jam_mulai': '08:00', 'jam_selesai': '11:20'},
      {'id': 108, 'nama_matakuliah': 'Data Mining', 'jumlah_sks': 3, 'dosen': 'Siti Delima Sari, M.Kom.', 'nama_hari': 'Rabu', 'jam_mulai': '13:00', 'jam_selesai': '15:30'},
      {'id': 109, 'nama_matakuliah': 'Etika Profesi & Bimbingan Karir', 'jumlah_sks': 2, 'dosen': 'Riyanti Yunita, M.Kom.', 'nama_hari': 'Kamis', 'jam_mulai': '08:00', 'jam_selesai': '09:40'},
      {'id': 110, 'nama_matakuliah': 'Bahasa Indonesia', 'jumlah_sks': 2, 'dosen': 'Uki Hares Y., M.Pd.', 'nama_hari': 'Kamis', 'jam_mulai': '10:00', 'jam_selesai': '11:40'},

      // === TAMBAHAN (SEMESTER 6, 7, dll) biar rame ===
      {'id': 201, 'nama_matakuliah': 'Metodologi Penelitian', 'jumlah_sks': 2, 'dosen': 'Dr. Prof. X', 'nama_hari': 'Jumat', 'jam_mulai': '08:00', 'jam_selesai': '09:40'},
      {'id': 202, 'nama_matakuliah': 'Kerja Praktek (KP)', 'jumlah_sks': 2, 'dosen': 'Tim Dosen', 'nama_hari': 'Sabtu', 'jam_mulai': '08:00', 'jam_selesai': '12:00'},
      {'id': 203, 'nama_matakuliah': 'Kuliah Kerja Nyata (KKN)', 'jumlah_sks': 4, 'dosen': 'LPPM', 'nama_hari': '-', 'jam_mulai': '-', 'jam_selesai': '-'},
      {'id': 204, 'nama_matakuliah': 'Skripsi / Tugas Akhir', 'jumlah_sks': 6, 'dosen': 'Pembimbing', 'nama_hari': '-', 'jam_mulai': '-', 'jam_selesai': '-'},
      {'id': 205, 'nama_matakuliah': 'Kapita Selekta', 'jumlah_sks': 2, 'dosen': 'Dosen Tamu', 'nama_hari': 'Jumat', 'jam_mulai': '13:00', 'jam_selesai': '14:40'},
    ];

    setState(() {
      availableCourses = manualData;
      _calculateTotalSKS();
    });
  }

  // ✅ RIWAYAT SMT 1-4 LENGKAP
  void _loadHistoryManual() {
    historyKrs = [
      // SEMESTER 1
      {'nama_matakuliah': 'MATEMATIKA DISKRIT', 'jumlah_sks': 3, 'dosen': 'Dr. Ahmad', 'semester_info': '1'},
      {'nama_matakuliah': 'ADMINISTRASI BISNIS', 'jumlah_sks': 2, 'dosen': 'Ir. Budi', 'semester_info': '1'},
      {'nama_matakuliah': 'ENGLISH', 'jumlah_sks': 3, 'dosen': 'Ms. Sarah', 'semester_info': '1'},
      {'nama_matakuliah': 'KALKULUS', 'jumlah_sks': 2, 'dosen': 'Dr. Chandra', 'semester_info': '1'},
      {'nama_matakuliah': 'ALGORITMA', 'jumlah_sks': 3, 'dosen': 'Ir. Dedi', 'semester_info': '1'},
      {'nama_matakuliah': 'DESAIN GRAFIS', 'jumlah_sks': 3, 'dosen': 'Drs. Eko', 'semester_info': '1'},
      {'nama_matakuliah': 'PENGANTAR TI', 'jumlah_sks': 2, 'dosen': 'Dr. Fajar', 'semester_info': '1'},
      {'nama_matakuliah': 'MANAJEMEN', 'jumlah_sks': 2, 'dosen': 'Ir. Gita', 'semester_info': '1'},
      {'nama_matakuliah': 'BAHASA ASING', 'jumlah_sks': 2, 'dosen': 'Ms. Hani', 'semester_info': '1'},
      
      // SEMESTER 2
      {'nama_matakuliah': 'ENGLISH 2', 'jumlah_sks': 2, 'dosen': 'Ms. Sarah', 'semester_info': '2'},
      {'nama_matakuliah': 'INTERAKSI MANUSIA & KOMPUTER', 'jumlah_sks': 2, 'dosen': 'Dr. Indra', 'semester_info': '2'},
      {'nama_matakuliah': 'SISTEM BERKAS', 'jumlah_sks': 2, 'dosen': 'Ir. Joko', 'semester_info': '2'},
      {'nama_matakuliah': 'STATISTIKA', 'jumlah_sks': 2, 'dosen': 'Dr. Kartika', 'semester_info': '2'},
      {'nama_matakuliah': 'SISTEM BASIS DATA', 'jumlah_sks': 3, 'dosen': 'Dr. Lina', 'semester_info': '2'},
      {'nama_matakuliah': 'KOMUNIKASI DATA', 'jumlah_sks': 3, 'dosen': 'Ir. Made', 'semester_info': '2'},
      {'nama_matakuliah': 'METODE NUMERIK', 'jumlah_sks': 2, 'dosen': 'Dr. Nina', 'semester_info': '2'},
      {'nama_matakuliah': 'SISTEM OPERASI', 'jumlah_sks': 3, 'dosen': 'Dr. Omar', 'semester_info': '2'},
      
      // SEMESTER 3
      {'nama_matakuliah': 'DESKTOP PROGRAMMING', 'jumlah_sks': 4, 'dosen': 'Dr. Qori', 'semester_info': '3'},
      {'nama_matakuliah': 'JARINGAN KOMPUTER', 'jumlah_sks': 3, 'dosen': 'Ir. Rani', 'semester_info': '3'},
      {'nama_matakuliah': 'KEWIRAUSAHAAN', 'jumlah_sks': 2, 'dosen': 'Drs. Siti', 'semester_info': '3'},
      {'nama_matakuliah': 'KONSEP PERANGKAT KERAS', 'jumlah_sks': 3, 'dosen': 'Ir. Tono', 'semester_info': '3'},
      {'nama_matakuliah': 'LOGIKA FUZZY', 'jumlah_sks': 2, 'dosen': 'Dr. Umar', 'semester_info': '3'},
      {'nama_matakuliah': 'SISTEM INFORMASI MANAJEMEN', 'jumlah_sks': 2, 'dosen': 'Ir. Vina', 'semester_info': '3'},
      {'nama_matakuliah': 'TEORI BAHASA & AUTOMATA', 'jumlah_sks': 3, 'dosen': 'Dr. Wawan', 'semester_info': '3'},
      {'nama_matakuliah': 'WEB PROGRAMMING', 'jumlah_sks': 4, 'dosen': 'Ir. Xena', 'semester_info': '3'},
      
      // SEMESTER 4
      {'nama_matakuliah': 'REKAYASA PERANGKAT LUNAK', 'jumlah_sks': 3, 'dosen': 'Dr. Yanto', 'semester_info': '4'},
      {'nama_matakuliah': 'ARSITEKTUR KOMPUTER', 'jumlah_sks': 3, 'dosen': 'Ir. Zaki', 'semester_info': '4'},
      {'nama_matakuliah': 'SPK', 'jumlah_sks': 3, 'dosen': 'Dr. Ani', 'semester_info': '4'},
      {'nama_matakuliah': 'BASIS DATA LANJUT', 'jumlah_sks': 4, 'dosen': 'Dr. Beni', 'semester_info': '4'},
      {'nama_matakuliah': 'BAHASA RAKITAN', 'jumlah_sks': 4, 'dosen': 'Ir. Citra', 'semester_info': '4'},
      {'nama_matakuliah': 'KRIPTOGRAFI', 'jumlah_sks': 3, 'dosen': 'Dr. Dani', 'semester_info': '4'},
      {'nama_matakuliah': 'PBO', 'jumlah_sks': 4, 'dosen': 'Dr. Erni', 'semester_info': '4'},
    ];
  }

  void _calculateTotalSKS() {
    int total = 0;
    for (var item in selectedCourses) {
      total += int.tryParse(item['jumlah_sks'].toString()) ?? 0;
    }
    setState(() => totalSKS = total);
  }

  // ================= LOGIC TOMBOL AMBIL =================

  Future<void> _toggleCourse(Map<String, dynamic> jadwal) async {
    if (isProcessing) return;

    var existingCourse = selectedCourses.firstWhere(
      (element) => element['id'] == jadwal['id'],
      orElse: () => null,
    );

    bool isSelected = existingCourse != null;
    int sksCourse = int.tryParse(jadwal['jumlah_sks'].toString()) ?? 0;

    if (!isSelected && (totalSKS + sksCourse > maxSKS)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SKS melebihi batas (Max 24)!')),
      );
      return;
    }

    setState(() => isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 300)); // Simulasi loading

    setState(() {
      if (!isSelected) {
        selectedCourses.add(jadwal);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil mengambil ${jadwal['nama_matakuliah']}"), backgroundColor: Colors.green, duration: const Duration(seconds: 1)),
        );
      } else {
        selectedCourses.removeWhere((element) => element['id'] == jadwal['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Dibatalkan: ${jadwal['nama_matakuliah']}"), backgroundColor: Colors.orange, duration: const Duration(seconds: 1)),
        );
      }
      _calculateTotalSKS();
      isProcessing = false;
    });
  }

  Future<void> _deleteDirectly(int idJadwal) async {
    var course = selectedCourses.firstWhere((e) => e['id'] == idJadwal, orElse: () => null);
    if(course != null){
       await _toggleCourse(course);
    }
  }

  Future<void> _navigateToJadwal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? "dummy";
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JadwalScreen(authToken: token)),
      );
    } catch (e) {
      print("Nav Error: $e");
    }
  }

  // ================= UI BUILDER =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeaderCard(),
                    Container(
                      color: Colors.transparent,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: [
                          const Tab(text: 'Pilih MK'),
                          Tab(text: 'Terpilih (${selectedCourses.length})'),
                          const Tab(text: 'Riwayat'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                        ),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAvailableCoursesTab(),
                            _buildSelectedCoursesTab(),
                            _buildHistoryTab(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'KRS Semester $currentSemester',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(Icons.schedule, color: Color(0xFF1976D2)),
                  onPressed: _navigateToJadwal,
                  tooltip: "Lihat Jadwal Kuliah",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(child: _infoBlock('SKS Terambil', '$totalSKS', color: totalSKS > maxSKS ? Colors.red : Colors.blue)),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                Expanded(child: _infoBlock('Maks SKS', '$maxSKS')),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                Expanded(child: _infoBlock('Matkul', '${selectedCourses.length}', color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: _navigateToJadwal,
              icon: const Icon(Icons.calendar_month),
              label: const Text('Lihat Jadwal Kuliah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBlock(String title, String value, {Color? color}) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
      ],
    );
  }

  Widget _buildAvailableCoursesTab() {
    if (availableCourses.isEmpty) return const Center(child: Text('Tidak ada jadwal.'));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: availableCourses.length,
      itemBuilder: (context, index) {
        final course = availableCourses[index];
        bool isSelected = selectedCourses.any((c) => c['id'] == course['id']);

        return Opacity(
          opacity: isProcessing ? 0.5 : 1.0,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isSelected ? Colors.green : Colors.transparent, width: 2),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => _toggleCourse(course),
              title: Text(course['nama_matakuliah'] ?? 'Tanpa Nama', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text("${course['jumlah_sks']} SKS | ${course['dosen']}", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  Text("${course['nama_hari']}, ${course['jam_mulai']} - ${course['jam_selesai']}", style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.w500)),
                ],
              ),
              trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.add_circle_outline, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedCoursesTab() {
    if (selectedCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.class_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("Belum ada matakuliah diambil."),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: selectedCourses.length,
            itemBuilder: (context, index) {
              final course = selectedCourses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(course['nama_matakuliah'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${course['nama_hari']} | ${course['jam_mulai']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDirectly(course['id']),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============== UI RIWAYAT (LENGKAP) ==============
  Widget _buildHistoryTab() {
    if (historyKrs.isEmpty) return const Center(child: Text("Belum ada riwayat."));

    Map<String, List<dynamic>> groupedBySemester = {};
    for (var item in historyKrs) {
      String sem = item['semester_info']?.toString() ?? '0';
      if (!groupedBySemester.containsKey(sem)) {
        groupedBySemester[sem] = [];
      }
      groupedBySemester[sem]!.add(item);
    }

    List<String> sortedSemesters = groupedBySemester.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedSemesters.length,
      itemBuilder: (ctx, index) {
        String semester = sortedSemesters[index];
        List<dynamic> courses = groupedBySemester[semester]!;
        bool isExpanded = expandedSemesters[semester] ?? false;
        
        int totalSKSLocal = 0;
        for (var c in courses) {
          totalSKSLocal += int.tryParse(c['jumlah_sks']?.toString() ?? '0') ?? 0;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    expandedSemesters[semester] = !isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade800]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isExpanded ? Radius.zero : const Radius.circular(16),
                      bottomRight: isExpanded ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text('SEMESTER $semester', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      Text('$totalSKSLocal SKS', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Column(
                  children: courses.map((mk) => ListTile(
                    title: Text(mk['nama_matakuliah']),
                    subtitle: Text("${mk['jumlah_sks']} SKS | ${mk['dosen']}"),
                    dense: true,
                  )).toList(),
                )
            ],
          ),
        );
      },
    );
  }
}