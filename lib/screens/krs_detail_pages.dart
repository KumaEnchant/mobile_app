import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart'; // Pastikan path ini sesuai dengan project lu

class KRSScreen extends StatefulWidget {
  const KRSScreen({super.key});

  @override
  State<KRSScreen> createState() => _KRSScreenState();
}

class _KRSScreenState extends State<KRSScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // State Data
  Map<String, dynamic>? user;
  int? activeKrsId; // ID KRS untuk Semester 5
  
  // Data Lists
  List<dynamic> availableCourses = []; // Dari endpoint jadwal
  List<dynamic> selectedCourses = [];  // Dari endpoint detail-krs
  List<dynamic> historyKrs = [];       // Dari endpoint daftar-krs (filter smt 1-4)

  // Status & Loading
  bool isLoading = true;
  bool isProcessing = false; // Untuk handling saat klik matkul (biar gak double tap)
  
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

  // ====================================================
  // 1. LOGIC LOAD DATA (GABUNGAN DARI FILE LAMA LU)
  // ====================================================

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    await _getUserData();
    if (user != null) {
      await _ensureActiveKrsExists(); // Pastikan KRS Smt 5 ada
      await _loadHistory();           // Load smt 1-4
      await _loadCoursesData();       // Load jadwal & matkul terpilih
    }
    setState(() => isLoading = false);
  }

  Future<void> _getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('auth_email');
      
      if (token == null) return;

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        "${ApiService.baseUrl}mahasiswa/detail-mahasiswa",
        data: {"email": email},
      );
      
      setState(() {
        user = response.data['data'];
      });
    } catch (e) {
      debugPrint("Gagal load user: $e");
    }
  }

  // Cek apakah KRS Semester 5 sudah ada, kalau belum, buatkan otomatis
  Future<void> _ensureActiveKrsExists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      // 1. Cek daftar KRS dulu
      final response = await dio.get(
        "${ApiService.baseUrl}krs/daftar-krs?id_mahasiswa=${user!['nim']}",
      );

      if (response.statusCode == 200) {
        List data = response.data['data'] ?? [];
        // Cari semester 5
        var active = data.firstWhere(
          (krs) => krs['semester'].toString() == currentSemester.toString(),
          orElse: () => null,
        );

        if (active != null) {
          activeKrsId = active['id'];
        } else {
          // 2. Kalau belum ada, Create KRS Semester 5
          await _createActiveKrs(dio);
        }
      }
    } catch (e) {
      debugPrint("Error check KRS: $e");
    }
  }

  Future<void> _createActiveKrs(Dio dio) async {
    try {
      final response = await dio.post(
        "${ApiService.baseUrl}krs/buat-krs",
        data: {'nim': user?['nim'], 'semester': currentSemester.toString()},
      );
      // Ambil ID dari response atau reload list (disini kita reload list biar aman)
      if (response.statusCode == 201 || response.statusCode == 202) {
         // Recursive call untuk mendapatkan ID setelah dibuat
         final listRes = await dio.get("${ApiService.baseUrl}krs/daftar-krs?id_mahasiswa=${user!['nim']}");
         List data = listRes.data['data'] ?? [];
         var active = data.firstWhere((krs) => krs['semester'].toString() == currentSemester.toString());
         activeKrsId = active['id'];
      }
    } catch (e) {
      debugPrint("Gagal buat KRS otomatis: $e");
    }
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        "${ApiService.baseUrl}krs/daftar-krs?id_mahasiswa=${user!['nim']}",
      );

      if (response.statusCode == 200) {
        List allKrs = response.data['data'] ?? [];
        // Filter: Hanya tampilkan semester SEBELUM semester 5 untuk tab Riwayat
        setState(() {
          historyKrs = allKrs.where((k) => int.parse(k['semester'].toString()) < currentSemester).toList();
        });
      }
    } catch (e) {
      debugPrint("Error load history: $e");
    }
  }

  Future<void> _loadCoursesData() async {
    if (activeKrsId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      // 1. Load Jadwal Tersedia (Available)
      final resJadwal = await dio.get("${ApiService.baseUrl}jadwal/daftar-jadwal");
      
      // 2. Load Matkul Terpilih (Selected) di KRS Aktif
      final resSelected = await dio.get("${ApiService.baseUrl}krs/detail-krs?id_krs=$activeKrsId");

      setState(() {
        availableCourses = resJadwal.data['jadwals'] ?? [];
        selectedCourses = resSelected.data['data'] ?? [];
        _calculateTotalSKS();
      });
    } catch (e) {
      debugPrint("Error load courses: $e");
    }
  }

  void _calculateTotalSKS() {
    int total = 0;
    for (var item in selectedCourses) {
      total += int.tryParse(item['jumlah_sks'].toString()) ?? 0;
    }
    setState(() => totalSKS = total);
  }

  // ====================================================
  // 2. LOGIC TOGGLE (ADD/REMOVE) - CORE FEATURE
  // ====================================================

  Future<void> _toggleCourse(Map<String, dynamic> jadwal) async {
    if (activeKrsId == null || isProcessing) return;

    // Cek apakah matkul ini sudah diambil (cek berdasarkan nama matkul karena ID jadwal vs ID detail beda)
    // Strategi: Cari di selectedCourses yang namanya sama dengan jadwal yang diklik
    var existingCourse = selectedCourses.firstWhere(
      (element) => element['nama_matakuliah'] == jadwal['nama_matakuliah'],
      orElse: () => null,
    );

    bool isSelected = existingCourse != null;
    int sksCourse = int.tryParse(jadwal['jumlah_sks'].toString()) ?? 0;

    // Validasi SKS jika mau nambah
    if (!isSelected && (totalSKS + sksCourse > maxSKS)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SKS melebihi batas maksimal!')));
      return;
    }

    setState(() => isProcessing = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      if (!isSelected) {
        // === TAMBAH MATKUL (Pakai ID JADWAL) ===
        await dio.post(
          "${ApiService.baseUrl}krs/tambah-course-krs",
          data: {"id_krs": activeKrsId, "id_jadwal": jadwal['id']},
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Berhasil ambil ${jadwal['nama_matakuliah']}")));
      } else {
        // === HAPUS MATKUL (Pakai ID DETAIL) ===
        // Kita harus pakai ID dari existingCourse (detail ID), bukan ID jadwal
        await dio.delete(
          "${ApiService.baseUrl}krs/hapus-course-krs?id=${existingCourse['id']}",
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dibatalkan: ${jadwal['nama_matakuliah']}")));
      }

      // Reload data untuk sinkronisasi UI
      await _loadCoursesData();

    } on DioException catch (e) {
      String err = e.response?.data['message'] ?? "Gagal memproses data";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.red));
    } finally {
      setState(() => isProcessing = false);
    }
  }

  // ====================================================
  // 3. UI COMPONENTS (ADAPTASI UI DOSEN)
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)])
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
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))
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
                  'KRS Semester $currentSemester', // Dinamis
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.person, color: Color(0xFF1976D2)),
                  onPressed: () { /* Info user profile optional */ },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Expanded(child: _infoBlock('SKS Terambil', '$totalSKS', color: totalSKS > maxSKS ? Colors.red : const Color(0xFF2196F3))),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                Expanded(child: _infoBlock('Maks SKS', '$maxSKS')),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                Expanded(child: _infoBlock('Mata Kuliah', '${selectedCourses.length}', color: const Color(0xFF4CAF50))),
              ],
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
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
      ],
    );
  }

  // --- TAB 1: PILIH MATKUL (AVAILABLE) ---
  Widget _buildAvailableCoursesTab() {
    if (availableCourses.isEmpty) {
      return const Center(child: Text('Tidak ada jadwal tersedia.'));
    }

    return RefreshIndicator(
      onRefresh: _loadCoursesData,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: availableCourses.length,
        itemBuilder: (context, index) {
          final course = availableCourses[index];
          
          // Cek apakah matkul ini sudah ada di selectedCourses
          // Kita bandingkan nama matkul karena ID jadwal != ID detail
          bool isSelected = selectedCourses.any((c) => c['nama_matakuliah'] == course['nama_matakuliah']);

          return Opacity(
            opacity: isProcessing ? 0.6 : 1.0,
            child: _buildCourseCard(
              course: course,
              isSelected: isSelected,
              onTap: () => _toggleCourse(course),
            ),
          );
        },
      ),
    );
  }

  // Card untuk Tab Pilih Matkul
  Widget _buildCourseCard({
    required Map<String, dynamic> course,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Mapping data API ke UI
    String namaMk = course['nama_matakuliah'] ?? 'No Name';
    String sks = course['jumlah_sks']?.toString() ?? '0';
    String dosen = course['dosen'] ?? 'Dosen Belum Ditentukan'; // Sesuaikan key API
    String jadwal = "${course['nama_hari'] ?? '-'}, ${course['jam_mulai'] ?? '-'}";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                            child: Text('$sks SKS', style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text(namaMk, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ]),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300], shape: BoxShape.circle),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(child: Text(dosen, style: TextStyle(color: Colors.grey[700]))),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(jadwal, style: TextStyle(color: Colors.grey[700])),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- TAB 2: MATKUL TERPILIH (SELECTED) ---
  Widget _buildSelectedCoursesTab() {
    if (selectedCourses.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('Belum ada matakuliah dipilih', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ]),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCoursesData,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: selectedCourses.length,
        itemBuilder: (context, index) {
          final course = selectedCourses[index];
          // Untuk Tab Selected, kita butuh tombol hapus
          // Kita butuh mapping balik ke object 'available' atau pakai logic delete langsung
          // Disini kita buat card khusus selected
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF4CAF50))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(course['nama_matakuliah'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red), 
                  onPressed: () {
                    // Logic hapus dari tab selected: cari jadwal yang namanya sama untuk ditrigger, atau langsung hit API
                    // Cara simple: tembak API delete pakai ID detail
                     _deleteDirectly(course['id'], course['nama_matakuliah']);
                  }
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(child: Text(course['dosen'] ?? '-', style: TextStyle(color: Colors.grey[700]))),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                 Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                 const SizedBox(width: 6),
                 Text("${course['nama_hari'] ?? '-'}, ${course['jam_mulai'] ?? '-'}", style: TextStyle(color: Colors.grey[700])),
              ]),
            ]),
          );
        },
      ),
    );
  }

  Future<void> _deleteDirectly(int idDetail, String namaMatkul) async {
     setState(() => isProcessing = true);
     try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        Dio dio = Dio();
        dio.options.headers['Authorization'] = 'Bearer $token';

        await dio.delete("${ApiService.baseUrl}krs/hapus-course-krs?id=$idDetail");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dihapus: $namaMatkul")));
        await _loadCoursesData();
     } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus")));
     } finally {
        setState(() => isProcessing = false);
     }
  }


  // --- TAB 3: RIWAYAT (HISTORY) ---
  Widget _buildHistoryTab() {
    if (historyKrs.isEmpty) return const Center(child: Text('Riwayat Smt 1-4 Kosong'));

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: historyKrs.length,
        itemBuilder: (context, index) {
          final krs = historyKrs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text("Semester ${krs['semester']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                  child: Text("Tahun: ${krs['tahun_ajaran']}", style: const TextStyle(color: Colors.blue, fontSize: 12)),
                ),
              ]),
              const Divider(),
              const Text("Data matakuliah pada semester ini tersimpan di sistem.", style: TextStyle(color: Colors.grey)),
            ]),
          );
        },
      ),
    );
  }
}