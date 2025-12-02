import 'package:flutter/material.dart';
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
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> courses = [
      {'name': 'Kewarganegaraan', 'code': 'MK001', 'lecturer': 'Lutvi Riyandari, S.Pd., M.Si.', 'idKrsDetail': 101, 'color': const Color(0xFF2196F3)},
      {'name': 'Pancasila', 'code': 'MK002', 'lecturer': 'Syah Firdaus, M.Si.', 'idKrsDetail': 102, 'color': const Color(0xFF4CAF50)},
      {'name': 'Manajemen Bisnis', 'code': 'MK003', 'lecturer': 'Novita Setianti, S.E., M.Ak.', 'idKrsDetail': 103, 'color': const Color(0xFF9C27B0)},
      {'name': 'Agama', 'code': 'MK004', 'lecturer': 'Ramelan, S.Pd., M.Pd.', 'idKrsDetail': 104, 'color': const Color(0xFFFF9800)},
      {'name': 'Technopreneurship', 'code': 'MK005', 'lecturer': 'Sunaryono, M.Kom.', 'idKrsDetail': 105, 'color': const Color(0xFFF44336)},
      {'name': 'Rangkaian Digital', 'code': 'MK006', 'lecturer': 'Singgih Setia A., S.Kom.', 'idKrsDetail': 106, 'color': const Color(0xFF00BCD4)},
      {'name': 'Mobile Programming', 'code': 'MK007', 'lecturer': 'M. Aziz Setia L., M.Kom.', 'idKrsDetail': 107, 'color': const Color(0xFF673AB7)},
      {'name': 'Data Mining', 'code': 'MK008', 'lecturer': 'Siti Delima Sari, M.Kom.', 'idKrsDetail': 108, 'color': const Color(0xFFE91E63)},
      {'name': 'Etika Profesi & Bimbingan Karir', 'code': 'MK009', 'lecturer': 'Riyanti Yunita, M.Kom.', 'idKrsDetail': 109, 'color': const Color(0xFF795548)},
      {'name': 'Bahasa Indonesia', 'code': 'MK010', 'lecturer': 'Uki Hares Y., M.Pd.', 'idKrsDetail': 110, 'color': const Color(0xFF607D8B)},
    ];

    setState(() {
      attendanceData = courses.map((item) => {
        ...item,
        'totalMeetings': 14,
        'attended': 0,
        'percentage': 0.0,
        'meetings': <Map<String, dynamic>>[],
      }).toList();
      isLoading = false;
    });
  }

  void _updateLocalStatus(int idKrsDetail, int pertemuan) {
    setState(() {
      int index = attendanceData.indexWhere((c) => c['idKrsDetail'] == idKrsDetail);
      
      if (index != -1) {
        var course = attendanceData[index];
        List<Map<String, dynamic>> meetings = List<Map<String, dynamic>>.from(course['meetings']);
        int meetingIndex = meetings.indexWhere((m) => m['pertemuan'].toString() == pertemuan.toString());

        if (meetingIndex != -1) {
          meetings[meetingIndex]['status'] = 'Hadir';
        } else {
          meetings.add({'pertemuan': pertemuan, 'status': 'Hadir'});
          course['attended'] = (course['attended'] as int) + 1;
        }

        course['meetings'] = meetings;
        course['percentage'] = (course['attended'] / 14) * 100;
        attendanceData[index] = course;

        debugPrint("✅ Updated: ${course['name']} - ${course['attended']} hadir, ${course['percentage'].toStringAsFixed(1)}%");
      }
    });
  }

  double get overallAttendancePercentage {
    int total = 0;
    int hadir = 0;
    for (var c in attendanceData) {
      var meetings = c['meetings'] as List;
      if (meetings.isNotEmpty) {
        total += meetings.length;
        hadir += meetings.where((m) => m['status'] == 'Hadir').length;
      }
    }
    return total > 0 ? (hadir / total) * 100 : 0;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    int above75 = attendanceData.where((c) => (c['percentage'] as double) >= 75).length;
    int below75 = attendanceData.length - above75;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1976D2)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem('Kehadiran', '${overallAttendancePercentage.toStringAsFixed(0)}%', Colors.green),
                          _statItem('≥75%', '$above75', Colors.blue),
                          _statItem('<75%', '$below75', Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [Tab(text: 'Daftar Matkul'), Tab(text: 'Statistik')],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: attendanceData.length,
                        itemBuilder: (_, i) => _buildCourseCard(attendanceData[i]),
                      ),
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

  Widget _statItem(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (course['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.book, color: course['color']),
        ),
        title: Text(course['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['lecturer'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text("${course['attended']} / 14 Hadir", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: CircularProgressIndicator(
          value: (course['percentage'] as double) / 100,
          backgroundColor: Colors.grey[200],
          color: (course['percentage'] as double) >= 75 ? Colors.green : Colors.orange,
        ),
        onTap: () => _showMeetingList(course),
      ),
    );
  }

  void _showMeetingList(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final courseData = attendanceData.firstWhere((c) => c['idKrsDetail'] == course['idKrsDetail']);

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (courseData['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.class_, color: courseData['color']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(courseData['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("${courseData['attended']} / 14 Hadir", style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 30),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 14,
                      itemBuilder: (_, index) {
                        int pertemuan = index + 1;
                        var meetings = courseData['meetings'] as List<Map<String, dynamic>>;
                        
                        Map<String, dynamic>? meeting;
                        for (var m in meetings) {
                          if (m['pertemuan'].toString() == pertemuan.toString()) {
                            meeting = m;
                            break;
                          }
                        }

                        bool isPresent = meeting != null && meeting['status'] == 'Hadir';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isPresent ? Colors.green.shade50 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isPresent ? Colors.green.shade200 : Colors.grey.shade200),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPresent ? Colors.green : (courseData['color'] as Color).withOpacity(0.1),
                              child: Text('$pertemuan', style: TextStyle(color: isPresent ? Colors.white : courseData['color'], fontWeight: FontWeight.bold)),
                            ),
                            title: Text("Pertemuan $pertemuan"),
                            subtitle: Text(isPresent ? "Hadir ✅" : "Belum Absen", style: TextStyle(color: isPresent ? Colors.green : Colors.grey)),
                            trailing: isPresent
                                ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: courseData['color'],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(modalContext);
                                      await Future.delayed(const Duration(milliseconds: 200));

                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AbsenSubmitScreen(
                                            idKrsDetail: courseData['idKrsDetail'],
                                            pertemuan: pertemuan,
                                            namaMatkul: courseData['name'],
                                            topic: 'Pertemuan $pertemuan',
                                          ),
                                        ),
                                      );

                                      debugPrint("📥 Result: $result");
                                      
                                      if (result == true && mounted) {
                                        _updateLocalStatus(courseData['idKrsDetail'], pertemuan);
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("✅ Absen Pertemuan $pertemuan berhasil!"),
                                            backgroundColor: Colors.green,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                        
                                        await Future.delayed(const Duration(milliseconds: 500));
                                        if (mounted) {
                                          _showMeetingList(courseData);
                                        }
                                      }
                                    },
                                    child: const Text("Absen", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    List<Map<String, dynamic>> chartData = [];
    for (var course in attendanceData) {
      chartData.add({
        'name': course['name'],
        'attended': course['attended'],
        'percentage': course['percentage'],
        'color': course['color'],
      });
    }

    chartData.sort((a, b) => (b['percentage'] as double).compareTo(a['percentage'] as double));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "Total Kehadiran",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "${overallAttendancePercentage.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat(
                      "Total Pertemuan",
                      "${attendanceData.fold<int>(0, (sum, c) => sum + (c['meetings'] as List).length)}",
                      Icons.calendar_today,
                    ),
                    _miniStat(
                      "Total Hadir",
                      "${attendanceData.fold<int>(0, (sum, c) => sum + (c['attended'] as int))}",
                      Icons.check_circle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Ranking Kehadiran",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...chartData.asMap().entries.map((entry) {
            int index = entry.key;
            var data = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? Colors.amber
                          : index == 1
                              ? Colors.grey.shade400
                              : index == 2
                                  ? Colors.brown.shade300
                                  : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: index < 3 ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (data['percentage'] as double) / 100,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    (data['percentage'] as double) >= 75 ? Colors.green : Colors.orange,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${data['percentage'].toStringAsFixed(0)}%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: (data['percentage'] as double) >= 75 ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${data['attended']} / 14 Hadir",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            "Ringkasan Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _statusCard(
                  "Aman (≥75%)",
                  "${attendanceData.where((c) => (c['percentage'] as double) >= 75).length}",
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statusCard(
                  "Hati-hati (<75%)",
                  "${attendanceData.where((c) => (c['percentage'] as double) < 75).length}",
                  Colors.orange,
                  Icons.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _statusCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}