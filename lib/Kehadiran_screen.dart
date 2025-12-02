import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../api/api_service.dart'; // Pastikan import ApiService
import 'absen_submit_screen.dart';

class KehadiranScreen extends StatefulWidget {
  const KehadiranScreen({super.key});

  @override
  State<KehadiranScreen> createState() => _KehadiranScreenState();
}

class _KehadiranScreenState extends State<KehadiranScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;

  List<Map<String, dynamic>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchKehadiranData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ FETCH DATA KEHADIRAN DARI SERVER (dengan fallback ke dummy data)
  Future<void> _fetchKehadiranData() async {
    setState(() => isLoading = true);
    
    try {
      debugPrint("🔄 Fetching kehadiran data from server...");
      
      final dio = Dio();
      final response = await dio.get(
        "${ApiService.baseUrl}kehadiran/list",
        options: Options(
          validateStatus: (status) => status! < 500,
          headers: {
            "Content-Type": "application/json",
            // Jika menggunakan token auth:
            // "Authorization": "Bearer ${await ApiService.getToken()}",
          },
        ),
      );

      debugPrint("📥 Response status: ${response.statusCode}");
      debugPrint("📥 Response data: ${response.data}");

      if (response.statusCode == 200) {
        // Cek apakah response memiliki key 'data'
        final responseData = response.data;
        
        if (responseData is Map && responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'] ?? [];
          
          debugPrint("✅ Found ${data.length} courses from server");
          
          setState(() {
            attendanceData = data.map((item) {
              // Parse meetings dengan safe casting
              List<Map<String, dynamic>> meetings = [];
              
              if (item['meetings'] != null && item['meetings'] is List) {
                meetings = (item['meetings'] as List)
                    .map((m) {
                      if (m is Map) {
                        return Map<String, dynamic>.from(m);
                      }
                      return <String, dynamic>{};
                    })
                    .where((m) => m.isNotEmpty)
                    .toList();
              }
              
              debugPrint("  - ${item['nama_matkul']}: ${meetings.length} meetings");
              
              return {
                'name': item['nama_matkul']?.toString() ?? 'Unknown',
                'code': item['kode_matkul']?.toString() ?? '',
                'lecturer': item['dosen']?.toString() ?? '',
                'idKrsDetail': item['id_krs_detail'] ?? 0,
                'totalMeetings': item['total_pertemuan'] ?? 14,
                'attended': item['hadir'] ?? 0,
                'absent': item['alpha'] ?? 0,
                'permit': item['izin'] ?? 0,
                'sick': item['sakit'] ?? 0,
                'percentage': _parseDouble(item['persentase']),
                'color': _getColorForIndex(data.indexOf(item)),
                'meetings': meetings,
              };
            }).toList();
            
            isLoading = false;
          });
          
          debugPrint("✅ Kehadiran data loaded successfully from server");
        } else {
          throw Exception("Invalid response format: missing 'data' key");
        }
      } else if (response.statusCode == 404) {
        // Endpoint belum ada, gunakan dummy data
        debugPrint("⚠️ Endpoint 404 - Using dummy data");
        _loadDummyData();
      } else {
        // Handle error response
        final errorMsg = response.data is Map 
            ? response.data['message'] ?? 'Failed to load data'
            : 'Server error ${response.statusCode}';
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      debugPrint("❌ DioException: ${e.type}");
      debugPrint("❌ Error: ${e.message}");
      debugPrint("❌ Response: ${e.response?.data}");
      
      // Jika 404, gunakan dummy data
      if (e.response?.statusCode == 404) {
        debugPrint("⚠️ Endpoint not found - Using dummy data");
        _loadDummyData();
        return;
      }
      
      setState(() => isLoading = false);
      
      String errorMsg = "Gagal memuat data kehadiran";
      
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data['message'] != null) {
          errorMsg = e.response!.data['message'];
        } else {
          errorMsg = "Server error: ${e.response!.statusCode}";
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = "Koneksi timeout";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = "Tidak dapat terhubung ke server";
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _fetchKehadiranData,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Unexpected error: $e");
      setState(() => isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ DUMMY DATA (digunakan jika endpoint belum siap)
  void _loadDummyData() {
    debugPrint("📦 Loading dummy data...");
    
    setState(() {
      attendanceData = [
        {
          'name': 'Kewarganegaraan',
          'code': '1',
          'lecturer': 'Lutvi Riyandari,S.Pd,M.Si',
          'idKrsDetail': 101,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF2196F3),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Pancasila',
          'code': '6',
          'lecturer': 'Syah Firdaus Palumpun,M.Si',
          'idKrsDetail': 102,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF4CAF50),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Manajemen Bisnis',
          'code': '7',
          'lecturer': 'Novita Setianti,S.E,M.Ak,Ak.CA',
          'idKrsDetail': 103,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF9C27B0),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Agama',
          'code': '107',
          'lecturer': 'Ramelan,S.Pd,M.Pd',
          'idKrsDetail': 104,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFFFF9800),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Technopreneurship',
          'code': '110',
          'lecturer': 'Sunaryono,M.Kom',
          'idKrsDetail': 105,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFFF44336),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Rangkaian Digital',
          'code': '18',
          'lecturer': 'Singgih Setia Andiko,S.Kom',
          'idKrsDetail': 106,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF009688),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Mobile Programming',
          'code': '116',
          'lecturer': 'Muhamad Aziz Setia Laksono,M.Kom',
          'idKrsDetail': 107,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF00BCD4),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Data Mining',
          'code': '117',
          'lecturer': 'Siti Delima Sari,M.Kom',
          'idKrsDetail': 108,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF673AB7),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Etika Profesi & Bimbingan Karir',
          'code': '127',
          'lecturer': 'Riyanti Yunita K,S.Pd,M.Kom',
          'idKrsDetail': 109,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFFE91E63),
          'meetings': <Map<String, dynamic>>[],
        },
        {
          'name': 'Bahasa Indonesia',
          'code': '8',
          'lecturer': 'Uki Hares Yulianti,S.Pd,M.Pd.',
          'idKrsDetail': 110,
          'totalMeetings': 14,
          'attended': 0,
          'absent': 0,
          'permit': 0,
          'sick': 0,
          'percentage': 0.0,
          'color': const Color(0xFF607D8B),
          'meetings': <Map<String, dynamic>>[],
        },
      ];
      
      isLoading = false;
    });
    
    debugPrint("✅ Dummy data loaded");
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Menggunakan data dummy (endpoint backend belum siap)"),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  
  // Helper untuk parse double dari berbagai tipe
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFF2196F3),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFFF9800),
      const Color(0xFFF44336),
      const Color(0xFF009688),
      const Color(0xFF00BCD4),
      const Color(0xFF673AB7),
      const Color(0xFFE91E63),
      const Color(0xFF607D8B),
    ];
    return colors[index % colors.length];
  }

  double get overallAttendancePercentage {
    int totalMeetingsSoFar = 0;
    int totalCountedAsPresent = 0;

    for (var course in attendanceData) {
      final meetings = course['meetings'] as List<Map<String, dynamic>>;
      totalMeetingsSoFar += meetings.length;
      totalCountedAsPresent += (course['attended'] as int) +
          (course['permit'] as int) +
          (course['sick'] as int);
    }

    return totalMeetingsSoFar > 0
        ? (totalCountedAsPresent / totalMeetingsSoFar) * 100
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final totalCourses = attendanceData.length;
    final coursesAbove75 =
        attendanceData.where((c) => (c['percentage'] as double) >= 75).length;
    final coursesBelow75 = totalCourses - coursesAbove75;

    return Scaffold(
      body: Container(
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
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Kehadiran',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.refresh, color: Color(0xFF1976D2)),
                            onPressed: _fetchKehadiranData,
                            tooltip: "Refresh data",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Overall Attendance Card
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
                      child: Column(
                        children: [
                          Text(
                            'Persentase Kehadiran',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  value: overallAttendancePercentage / 100,
                                  strokeWidth: 12,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    overallAttendancePercentage >= 75
                                        ? const Color(0xFF4CAF50)
                                        : overallAttendancePercentage >= 50
                                            ? const Color(0xFFFF9800)
                                            : const Color(0xFFF44336),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${overallAttendancePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: overallAttendancePercentage >= 75
                                          ? const Color(0xFF4CAF50)
                                          : overallAttendancePercentage >= 50
                                              ? const Color(0xFFFF9800)
                                              : const Color(0xFFF44336),
                                    ),
                                  ),
                                  Text(
                                    'Keseluruhan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn(
                                '≥75%',
                                '$coursesAbove75',
                                const Color(0xFF4CAF50),
                                'Mata Kuliah',
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[300],
                              ),
                              _buildStatColumn(
                                '<75%',
                                '$coursesBelow75',
                                const Color(0xFFF44336),
                                'Mata Kuliah',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                color: Colors.transparent,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  tabs: const [
                    Tab(text: 'Per Mata Kuliah'),
                    Tab(text: 'Statistik'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCourseListTab(),
                      _buildStatisticsTab(),
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

  Widget _buildStatColumn(String label, String value, Color color, String subtitle) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildCourseListTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: attendanceData.length,
      itemBuilder: (context, index) => _buildCourseAttendanceCard(attendanceData[index]),
    );
  }

  Widget _buildCourseAttendanceCard(Map<String, dynamic> course) {
    final percentage = course['percentage'] as double;
    final color = course['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCourseDetail(course),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              course['code'].toString(),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course['name'].toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course['lecturer'].toString(),
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: percentage >= 75 ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, size: 18, color: color),
                      const SizedBox(width: 8),
                      Text(
                        'Klik untuk lihat daftar pertemuan',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_month, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'Statistik Kehadiran',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data kehadiran Anda dari semua mata kuliah',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseDetail(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (course['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.book, color: course['color'] as Color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course['code'].toString(), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text(course['name'].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(course['lecturer'].toString(), style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Daftar Pertemuan (14 pertemuan)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 14,
                itemBuilder: (context, index) {
                  final pertemuan = index + 1;
                  final meetings = course['meetings'] as List<Map<String, dynamic>>;
                  final meeting = meetings.firstWhere(
                    (m) => m['pertemuan'] == pertemuan,
                    orElse: () => {},
                  );
                  final status = meeting.isEmpty ? 'Belum absen' : meeting['status'] ?? 'Belum absen';
                  
                  return _buildPertemuanCard(course, pertemuan, status);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPertemuanCard(Map<String, dynamic> course, int pertemuan, String status) {
    final color = course['color'] as Color;
    final isAbsent = status != 'Belum absen';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAbsent ? null : () async {
            Navigator.pop(context);

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AbsenSubmitScreen(
                  idKrsDetail: course['idKrsDetail'] as int,
                  pertemuan: pertemuan,
                  namaMatkul: course['name'].toString(),
                  topic: 'Pertemuan $pertemuan',
                ),
              ),
            );

            // ✅ REFRESH DATA SETELAH ABSEN BERHASIL
            if (result == true && mounted) {
              await _fetchKehadiranData();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ Data kehadiran diperbarui!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$pertemuan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pertemuan $pertemuan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(status, style: TextStyle(fontSize: 13, color: isAbsent ? Colors.green : Colors.grey[600])),
                    ],
                  ),
                ),
                if (!isAbsent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text('Absen', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  )
                else
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}