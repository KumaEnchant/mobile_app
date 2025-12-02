import 'package:flutter/material.dart';

class JadwalScreen extends StatefulWidget {
  final String? authToken;

  const JadwalScreen({super.key, this.authToken});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  int selectedDayIndex = 0; // Default Senin
  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  // ✅ DATA MANUAL SEMESTER 5 (SINKRON DENGAN KRS)
  late Map<String, List<Map<String, dynamic>>> scheduleData;

  @override
  void initState() {
    super.initState();
    _loadSemester5Data();
  }

  void _loadSemester5Data() {
    scheduleData = {
      'Senin': [
        {
          'name': 'Kewarganegaraan',
          'code': 'MK001',
          'time': '08:00 - 09:40',
          'room': 'R.2.1',
          'building': 'Gedung B',
          'lecturer': 'Lutvi Riyandari, S.Pd., M.Si.',
          'credits': 2,
          'type': 'Teori',
          'color': const Color(0xFF2196F3),
        },
        {
          'name': 'Pancasila',
          'code': 'MK002',
          'time': '10:00 - 11:40',
          'room': 'R.2.2',
          'building': 'Gedung B',
          'lecturer': 'Syah Firdaus, M.Si.',
          'credits': 2,
          'type': 'Teori',
          'color': const Color(0xFF4CAF50),
        },
        {
          'name': 'Manajemen Bisnis',
          'code': 'MK003',
          'time': '13:00 - 14:40',
          'room': 'R.3.1',
          'building': 'Gedung A',
          'lecturer': 'Novita Setianti, S.E., M.Ak.',
          'credits': 2,
          'type': 'Teori',
          'color': const Color(0xFF9C27B0),
        },
      ],
      'Selasa': [
        {
          'name': 'Agama',
          'code': 'MK004',
          'time': '08:00 - 09:40',
          'room': 'Musholla Lt.1',
          'building': 'Gedung C',
          'lecturer': 'Ramelan, S.Pd., M.Pd.',
          'credits': 2,
          'type': 'Teori',
          'color': const Color(0xFFFF9800),
        },
        {
          'name': 'Technopreneurship',
          'code': 'MK005',
          'time': '10:00 - 11:40',
          'room': 'Lab Multimedia',
          'building': 'Gedung A',
          'lecturer': 'Sunaryono, M.Kom.',
          'credits': 2,
          'type': 'Praktikum',
          'color': const Color(0xFFF44336),
        },
        {
          'name': 'Rangkaian Digital',
          'code': 'MK006',
          'time': '13:00 - 15:30',
          'room': 'Lab Hardware',
          'building': 'Gedung B',
          'lecturer': 'Singgih Setia A., S.Kom.',
          'credits': 3,
          'type': 'Praktikum',
          'color': const Color(0xFF00BCD4),
        },
      ],
      'Rabu': [
        {
          'name': 'Mobile Programming',
          'code': 'MK007',
          'time': '08:00 - 11:20',
          'room': 'Lab Komputer 1',
          'building': 'Gedung A',
          'lecturer': 'M. Aziz Setia L., M.Kom.',
          'credits': 4,
          'type': 'Praktikum',
          'color': const Color(0xFF673AB7),
        },
        {
          'name': 'Data Mining',
          'code': 'MK008',
          'time': '13:00 - 15:30',
          'room': 'Lab Komputer 3',
          'building': 'Gedung A',
          'lecturer': 'Siti Delima Sari, M.Kom.',
          'credits': 3,
          'type': 'Praktikum',
          'color': const Color(0xFFE91E63),
        },
      ],
      'Kamis': [
        {
          'name': 'Etika Profesi & Bimbingan Karir',
          'code': 'MK009',
          'time': '08:00 - 09:40',
          'room': 'R.1.3',
          'building': 'Gedung B',
          'lecturer': 'Riyanti Yunita, M.Kom.',
          'credits': 2,
          'type': 'Teori',
          'color': const Color(0xFF795548),
        },
        {
          'name': 'Bahasa Indonesia',
          'code': 'MK010',
          'time': '10:00 - 11:40',
          'room': 'R.1.4',
          'building': 'Gedung B',
          'lecturer': 'Uki Hares Y., M.Pd.',
          'credits': 2,
          'type': 'Teori',
          'color': const Color(0xFF607D8B),
        },
      ],
      'Jumat': [],
      'Sabtu': [],
    };
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil jadwal berdasarkan hari yang dipilih
    final currentSchedule = scheduleData[days[selectedDayIndex]] ?? [];
    
    // Info Card Calculations
    final totalClassesToday = currentSchedule.length;
    int totalHoursToday = 0;
    if (currentSchedule.isNotEmpty) {
       totalHoursToday = totalClassesToday * 2; // Estimasi kasar
    }

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
                            'Jadwal Kuliah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Tombol Kalender
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.calendar_month, color: Color(0xFF1976D2)),
                            onPressed: _showCalendarDialog,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.class_outlined,
                            iconColor: const Color(0xFF2196F3),
                            value: '$totalClassesToday',
                            label: 'Kelas Hari Ini',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.access_time,
                            iconColor: const Color(0xFF4CAF50),
                            value: '$totalHoursToday Jam',
                            label: 'Estimasi Durasi',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Days Tabs
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedDayIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            days[index],
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF1976D2) : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Schedule List Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: currentSchedule.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: currentSchedule.length,
                          itemBuilder: (context, index) {
                            final schedule = currentSchedule[index];
                            return _buildScheduleCard(schedule);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada jadwal kuliah',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Hari ${days[selectedDayIndex]} kosong/libur.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required Color iconColor, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
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
          onTap: () => _showScheduleDetail(schedule),
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
                      height: 80,
                      decoration: BoxDecoration(
                        color: schedule['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: schedule['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  schedule['code'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: schedule['color'],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (schedule['type'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: schedule['type'] == 'Praktikum' ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    schedule['type'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: schedule['type'] == 'Praktikum' ? Colors.orange : Colors.blue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            schedule['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                schedule['time'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        schedule['lecturer'],
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.room_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${schedule['room']} - ${schedule['building']}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(Icons.credit_card, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${schedule['credits']} SKS',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleDetail(Map<String, dynamic> schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                schedule['name'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Kode: ${schedule['code']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(Icons.access_time, 'Waktu', schedule['time'], Colors.blue),
              _buildDetailRow(Icons.room, 'Ruangan', '${schedule['room']} (${schedule['building']})', Colors.green),
              _buildDetailRow(Icons.person, 'Dosen', schedule['lecturer'], Colors.orange),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tutup'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kalender Akademik'),
        content: const Text('Ini adalah jadwal perkuliahan Semester 5.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}