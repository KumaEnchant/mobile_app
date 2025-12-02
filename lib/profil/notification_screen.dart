import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Notification settings
  bool _pushNotification = true;
  bool _emailNotification = true;
  bool _jadwalKuliah = true;
  bool _jadwalUjian = true;
  bool _pengumuman = true;
  bool _tugasKuliah = true;
  bool _nilaiKeluar = true;
  bool _absensi = false;
  bool _pembayaran = true;
  bool _eventKampus = false;

  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Jadwal UTS Semester 5',
      'message': 'UTS akan dilaksanakan mulai tanggal 15-20 Oktober 2025. Pastikan Anda mempersiapkan diri dengan baik.',
      'type': 'pengumuman',
      'date': '10 Oktober 2025',
      'time': '09:30',
      'isRead': false,
      'icon': Icons.campaign,
      'color': Color(0xFF2196F3),
    },
    {
      'id': 2,
      'title': 'Nilai UTS Sudah Keluar',
      'message': 'Nilai UTS untuk mata kuliah Pemrograman Mobile Lanjut sudah dapat dilihat di menu Nilai.',
      'type': 'nilai',
      'date': '09 Oktober 2025',
      'time': '14:20',
      'isRead': false,
      'icon': Icons.grade,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': 3,
      'title': 'Reminder: Kuliah Hari Ini',
      'message': 'Anda memiliki 3 jadwal kuliah hari ini. Jangan lupa hadir tepat waktu!',
      'type': 'jadwal',
      'date': '08 Oktober 2025',
      'time': '07:00',
      'isRead': true,
      'icon': Icons.calendar_today,
      'color': Color(0xFF9C27B0),
    },
    {
      'id': 4,
      'title': 'Pembayaran SPP',
      'message': 'Batas akhir pembayaran SPP semester ini adalah 25 Oktober 2025. Segera lakukan pembayaran.',
      'type': 'pembayaran',
      'date': '05 Oktober 2025',
      'time': '10:15',
      'isRead': true,
      'icon': Icons.payment,
      'color': Color(0xFFFF9800),
    },
    {
      'id': 5,
      'title': 'Tugas Baru: Data Mining',
      'message': 'Tugas baru telah ditambahkan untuk mata kuliah Data Mining. Deadline: 20 Oktober 2025.',
      'type': 'tugas',
      'date': '03 Oktober 2025',
      'time': '16:45',
      'isRead': true,
      'icon': Icons.assignment,
      'color': Color(0xFFF44336),
    },
    {
      'id': 6,
      'title': 'Absensi Tidak Hadir',
      'message': 'Anda tidak hadir pada mata kuliah Cloud Computing hari ini. Persentase kehadiran: 78%',
      'type': 'absensi',
      'date': '02 Oktober 2025',
      'time': '13:30',
      'isRead': true,
      'icon': Icons.warning,
      'color': Color(0xFFF44336),
    },
    {
      'id': 7,
      'title': 'Event: Workshop AI',
      'message': 'Daftarkan diri Anda untuk mengikuti Workshop AI yang akan diadakan pada 15 November 2025.',
      'type': 'event',
      'date': '01 Oktober 2025',
      'time': '11:20',
      'isRead': true,
      'icon': Icons.event,
      'color': Color(0xFF00BCD4),
    },
    {
      'id': 8,
      'title': 'Perubahan Jadwal Kuliah',
      'message': 'Jadwal kuliah Kecerdasan Buatan dipindahkan dari Kamis ke Jumat pukul 10:00.',
      'type': 'jadwal',
      'date': '28 September 2025',
      'time': '15:10',
      'isRead': true,
      'icon': Icons.schedule,
      'color': Color(0xFF9C27B0),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get unreadCount => notifications.where((n) => !n['isRead']).length;

  void _markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Semua notifikasi ditandai sudah dibaca'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Semua Notifikasi?'),
        content: Text('Semua notifikasi akan dihapus. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Semua notifikasi telah dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Notifikasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (unreadCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFFF44336),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$unreadCount baru',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: unreadCount > 0 ? _markAllAsRead : null,
                            icon: Icon(Icons.done_all, size: 18),
                            label: Text('Tandai Dibaca'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF2196F3),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: notifications.isNotEmpty ? _clearAllNotifications : null,
                            icon: Icon(Icons.delete_outline, size: 18),
                            label: Text('Hapus Semua'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                  tabs: [
                    Tab(text: 'Notifikasi'),
                    Tab(text: 'Pengaturan'),
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
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationList(),
                      _buildSettingsTab(),
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

  Widget _buildNotificationList() {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada notifikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Notifikasi baru akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification['isRead'] ? Colors.grey[200]! : Color(0xFF2196F3).withOpacity(0.3),
          width: notification['isRead'] ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _markAsRead(notification['id']);
            _showNotificationDetail(notification);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!notification['isRead'])
                            Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFF2196F3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        notification['message'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          SizedBox(width: 4),
                          Text(
                            '${notification['date']} • ${notification['time']}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metode Notifikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          _buildSettingCard(
            icon: Icons.notifications_active,
            title: 'Push Notification',
            subtitle: 'Notifikasi melalui aplikasi',
            value: _pushNotification,
            onChanged: (value) {
              setState(() {
                _pushNotification = value;
              });
            },
            color: Color(0xFF2196F3),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.email,
            title: 'Email Notification',
            subtitle: 'Notifikasi melalui email',
            value: _emailNotification,
            onChanged: (value) {
              setState(() {
                _emailNotification = value;
              });
            },
            color: Color(0xFFFF9800),
          ),
          SizedBox(height: 24),

          Text(
            'Kategori Notifikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          _buildSettingCard(
            icon: Icons.calendar_today,
            title: 'Jadwal Kuliah',
            subtitle: 'Pengingat jadwal kuliah harian',
            value: _jadwalKuliah,
            onChanged: (value) {
              setState(() {
                _jadwalKuliah = value;
              });
            },
            color: Color(0xFF9C27B0),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.schedule,
            title: 'Jadwal Ujian',
            subtitle: 'Pengingat jadwal UTS & UAS',
            value: _jadwalUjian,
            onChanged: (value) {
              setState(() {
                _jadwalUjian = value;
              });
            },
            color: Color(0xFF3F51B5),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.campaign,
            title: 'Pengumuman',
            subtitle: 'Pengumuman dari kampus',
            value: _pengumuman,
            onChanged: (value) {
              setState(() {
                _pengumuman = value;
              });
            },
            color: Color(0xFF2196F3),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.assignment,
            title: 'Tugas Kuliah',
            subtitle: 'Tugas dan deadline',
            value: _tugasKuliah,
            onChanged: (value) {
              setState(() {
                _tugasKuliah = value;
              });
            },
            color: Color(0xFFF44336),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.grade,
            title: 'Nilai Keluar',
            subtitle: 'Notifikasi nilai UTS/UAS',
            value: _nilaiKeluar,
            onChanged: (value) {
              setState(() {
                _nilaiKeluar = value;
              });
            },
            color: Color(0xFF4CAF50),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.check_circle,
            title: 'Absensi',
            subtitle: 'Konfirmasi kehadiran',
            value: _absensi,
            onChanged: (value) {
              setState(() {
                _absensi = value;
              });
            },
            color: Color(0xFFFF9800),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.payment,
            title: 'Pembayaran',
            subtitle: 'Tagihan dan pembayaran SPP',
            value: _pembayaran,
            onChanged: (value) {
              setState(() {
                _pembayaran = value;
              });
            },
            color: Color(0xFFFF5722),
          ),
          SizedBox(height: 12),

          _buildSettingCard(
            icon: Icons.event,
            title: 'Event Kampus',
            subtitle: 'Acara dan kegiatan kampus',
            value: _eventKampus,
            onChanged: (value) {
              setState(() {
                _eventKampus = value;
              });
            },
            color: Color(0xFF00BCD4),
          ),
          SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Pengaturan notifikasi disimpan'),
                      ],
                    ),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(Icons.save),
              label: Text('Simpan Pengaturan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2196F3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: color,
        secondary: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: notification['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            notification['icon'],
                            color: notification['color'],
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                  SizedBox(width: 4),
                                  Text(
                                    '${notification['date']} • ${notification['time']}',
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
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: notification['color'],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Tutup'),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}