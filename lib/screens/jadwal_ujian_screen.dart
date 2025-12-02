import 'package:flutter/material.dart';

class JadwalUjianScreen extends StatefulWidget {
  const JadwalUjianScreen({super.key});

  @override
  State<JadwalUjianScreen> createState() => _JadwalUjianScreenState();
}

class _JadwalUjianScreenState extends State<JadwalUjianScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- PENAMBAHAN 1: Variabel untuk mengontrol visibilitas UAS ---
  // Ganti menjadi 'true' jika jadwal UAS sudah ingin ditampilkan
  final bool isUasAvailable = false;

  final Map<String, List<Map<String, dynamic>>> examSchedule = {
    'UTS': [
      {
        'name': 'Kewarganegaraan',
        'code': '1',
        'lecturer': 'Lutvi Riyandari,S.Pd,M.Si',
        'date': '20 Oktober 2025',
        'day': 'Senin',
        'time': '08:30 - 09:30',
        'duration': '60 menit',
        'room': 'Ruang 2.1',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF2196F3),
        'credits': 2,
        'materials': [
          'Hak dan Kewajiban Warga Negara',
          'Demokrasi & Konstitusi Indonesia',
          'Wawasan Nusantara',
          'Ketahanan Nasional'
        ],
        'notes': 'Ujian tulis, bawa alat tulis lengkap',
      },
      {
        'name': 'Pancasila',
        'code': '6',
        'lecturer': 'Syah Firdaus Palumpun,M.Si',
        'date': '20 Oktober 2025',
        'day': 'Senin',
        'time': '09:00 - 10:30',
        'duration': '90 menit',
        'room': 'Ruang 2.2',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF4CAF50),
        'credits': 2,
        'materials': [
          'Sejarah Perumusan Pancasila',
          'Fungsi dan Kedudukan Pancasila',
          'Butir-butir Pengamalan Pancasila',
          'Pancasila sebagai Ideologi Negara'
        ],
        'notes': 'Ujian bersifat hafalan dan pemahaman',
      },
      {
        'name': 'Manajemen Bisnis',
        'code': '7',
        'lecturer': 'Novita Setianti,S.E,M.Ak,Ak.CA',
        'date': '20 Oktober 2025',
        'day': 'Senin',
        'time': '10:30 - 11:30',
        'duration': '60 menit',
        'room': 'Ruang 2.2',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF9C27B0),
        'credits': 2,
        'materials': [
          'Pengantar Manajemen Bisnis',
          'Analisis SWOT',
          'Dasar-dasar Pemasaran',
          'Manajemen Operasional'
        ],
        'notes': 'Studi kasus, pemahaman konsep diutamakan',
      },
      {
        'name': 'Agama',
        'code': '107',
        'lecturer': 'Ramelan,S.Pd,M.Pd',
        'date': '21 Oktober 2025',
        'day': 'Selasa',
        'time': '09:00 - 10:00',
        'duration': '60 menit',
        'room': 'Ruang 1.1',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFFFF9800),
        'credits': 2,
        'materials': [
          'Konsep Ketuhanan',
          'Sumber Hukum Agama',
          'Sejarah Kenabian & Rasul',
          'Akhlak dan Moralitas'
        ],
        'notes': 'Closed book, bawa alat tulis',
      },
      {
        'name': 'Technopreneurship',
        'code': '110',
        'lecturer': 'Sunaryono,M.Kom',
        'date': '21 Oktober 2025',
        'day': 'Selasa',
        'time': '10:00 - 11:00',
        'duration': '60 menit',
        'room': 'Ruang 1.2',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Praktikum',
        'examType': 'Online',
        'color': Color(0xFFF44336),
        'credits': 2,
        'materials': [
          'Business Model Canvas (BMC)',
          'Value Proposition Design',
          'Market Research & Validation',
          'Pitching & Presentasi Ide'
        ],
        'notes': 'Presentasi progres proyek startup per kelompok',
      },
      {
        'name': 'Rangkaian Digital',
        'code': '18',
        'lecturer': 'Singgih Setia Andiko,S.Kom',
        'date': '21 Oktober 2025',
        'day': 'Selasa',
        'time': '13:00 - 14:30',
        'duration': '90 menit',
        'room': 'Ruang 2.1',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFFF44336),
        'credits': 3,
        'materials': [
          'Gerbang Logika Dasar (AND, OR, NOT, XOR)',
          'Aljabar Boolean & Penyederhanaan',
          'Rangkaian Kombinasional (Encoder, Decoder)',
          'Flip-Flop & Rangkaian Sekuensial'
        ],
        'notes': 'Boleh membawa kalkulator scientific',
      },
      {
        'name': 'Mobile Programing',
        'code': '116',
        'lecturer': 'Muhamad Aziz Setia Laksono,M.Kom',
        'date': '22 Oktober 2025',
        'day': 'Rabu',
        'time': '08:00 - 10:00',
        'duration': '120 menit',
        'room': 'Lab 1',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Praktikum',
        'examType': 'Online',
        'color': Color(0xFF00BCD4),
        'credits': 4,
        'materials': [
          'Dasar-dasar Flutter & Dart',
          'Stateful & Stateless Widget',
          'Layouting (Row, Column, Stack)',
          'Navigasi & Routing Antar Halaman'
        ],
        'notes': 'Bawa laptop dengan Flutter SDK terinstall',
      },
      {
        'name': 'Data Mining',
        'code': '117',
        'lecturer': 'Siti Delima Sari,M.Kom',
        'date': '22 Oktober 2025',
        'day': 'Rabu',
        'time': '10:00 - 11:30',
        'duration': '90 menit',
        'room': 'Lab 1',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Praktikum',
        'examType': 'Hybrid',
        'color': Color(0xFF673AB7),
        'credits': 3,
        'materials': [
          'Data Preprocessing (Cleaning & Transformation)',
          'Algoritma Klasifikasi (Decision Tree, Naive Bayes)',
          'Algoritma Clustering (K-Means)',
          'Asosiasi (Apriori)'
        ],
        'notes': 'Ujian praktek menggunakan Python (Jupyter/Colab)',
      },
      {
        'name': 'Etika Profesi & Bimbingan Karir',
        'code': '127',
        'lecturer': 'Riyanti Yunita K,S.Pd,M.Kom',
        'date': '23 Oktober 2025',
        'day': 'Kamis',
        'time': '13:00 - 14:00',
        'duration': '60 menit',
        'room': 'Ruang 1.3',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFFE91E63),
        'credits': 2,
        'materials': [
          'Kode Etik Profesi IT',
          'Cyber Ethics & UU ITE',
          'Hak Kekayaan Intelektual (HAKI)',
          'Teknik Pembuatan CV & Wawancara'
        ],
        'notes': 'Ujian dalam bentuk esai studi kasus',
      },
      {
        'name': 'Bahasa Indonesia',
        'code': '8',
        'lecturer': 'Uki Hares Yulianti,S.Pd,M.Pd.',
        'date': '23 Oktober 2025',
        'day': 'Kamis',
        'time': '14:00 - 15:00',
        'duration': '60 menit',
        'room': 'Ruang 1.4',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF607D8B),
        'credits': 2,
        'materials': [
          'Ejaan Yang Disempurnakan (PUEBI)',
          'Kalimat Efektif',
          'Pengembangan Paragraf',
          'Penulisan Karya Ilmiah'
        ],
        'notes': 'Fokus pada tata bahasa dan penulisan yang benar',
      }
    ],
    'UAS': [
      {
        'name': 'Kewarganegaraan',
        'code': '1',
        'lecturer': 'Lutvi Riyandari,S.Pd,M.Si',
        'date': '15 Desember 2025',
        'day': 'Senin',
        'time': '08:30 - 09:30',
        'duration': '60 menit',
        'room': 'Ruang 2.1',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF2196F3),
        'credits': 2,
        'materials': [
          'Geopolitik Indonesia',
          'Studi Kasus Integrasi Nasional',
          'Tantangan Demokrasi Pancasila',
          'Peran Indonesia di Kancah Internasional'
        ],
        'notes': 'Ujian esai, analisis isu-isu terkini',
      },
      {
        'name': 'Pancasila',
        'code': '6',
        'lecturer': 'Syah Firdaus Palumpun,M.Si',
        'date': '15 Desember 2025',
        'day': 'Senin',
        'time': '09:00 - 10:30',
        'duration': '90 menit',
        'room': 'Ruang 2.2',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF4CAF50),
        'credits': 2,
        'materials': [
          'Dinamika dan Tantangan Pancasila',
          'Pancasila sebagai Sistem Filsafat',
          'Pancasila sebagai Sistem Etika',
          'Implementasi Nilai-nilai Pancasila'
        ],
        'notes': 'Studi kasus relevansi Pancasila di era modern',
      },
      {
        'name': 'Manajemen Bisnis',
        'code': '7',
        'lecturer': 'Novita Setianti,S.E,M.Ak,Ak.CA',
        'date': '15 Desember 2025',
        'day': 'Senin',
        'time': '10:30 - 11:30',
        'duration': '60 menit',
        'room': 'Ruang 2.2',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF9C27B0),
        'credits': 2,
        'materials': [
          'Manajemen Keuangan Bisnis',
          'Manajemen Sumber Daya Manusia',
          'Strategi Pemasaran Digital',
          'Etika Bisnis dan Tanggung Jawab Sosial'
        ],
        'notes': 'Pembuatan rencana bisnis sederhana',
      },
      {
        'name': 'Agama',
        'code': '107',
        'lecturer': 'Ramelan,S.Pd,M.Pd',
        'date': '16 Desember 2025',
        'day': 'Selasa',
        'time': '09:00 - 10:00',
        'duration': '60 menit',
        'room': 'Ruang 1.1',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFFFF9800),
        'credits': 2,
        'materials': [
          'Kerukunan Antar Umat Beragama',
          'Agama sebagai Solusi Problematika Modern',
          'Ilmu Pengetahuan dan Teknologi dalam Perspektif Agama',
          'Fiqih Muamalah (Ekonomi Syariah)'
        ],
        'notes': 'Comprehensive exam, pemahaman mendalam',
      },
      {
        'name': 'Technopreneurship',
        'code': '110',
        'lecturer': 'Sunaryono,M.Kom',
        'date': '16 Desember 2025',
        'day': 'Selasa',
        'time': '10:00 - 11:00',
        'duration': '60 menit',
        'room': 'Ruang 1.2',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Praktikum',
        'examType': 'Online',
        'color': Color(0xFFF44336),
        'credits': 2,
        'materials': [
          'Validasi Produk & Pasar',
          'Strategi Go-to-Market',
          'Dasar-dasar Pendanaan Startup',
          'Manajemen Keuangan untuk Startup'
        ],
        'notes': 'Final pitch deck dan demo prototipe produk',
      },
      {
        'name': 'Rangkaian Digital',
        'code': '18',
        'lecturer': 'Singgih Setia Andiko,S.Kom',
        'date': '16 Desember 2025',
        'day': 'Selasa',
        'time': '13:00 - 14:30',
        'duration': '90 menit',
        'room': 'Ruang 2.1',
        'building': 'Gedung 2',
        'floor': 'Lantai 2',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFFF44336),
        'credits': 3,
        'materials': [
          'Register dan Counter',
          'Memory (RAM, ROM)',
          'Rangkaian Aritmatika (Adder, Subtractor)',
          'Pengantar Arsitektur Komputer'
        ],
        'notes': 'Soal hitungan dan perancangan rangkaian',
      },
      {
        'name': 'Mobile Programing',
        'code': '116',
        'lecturer': 'Muhamad Aziz Setia Laksono,M.Kom',
        'date': '17 Desember 2025',
        'day': 'Rabu',
        'time': '08:00 - 10:00',
        'duration': '120 menit',
        'room': 'Lab 1',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Praktikum',
        'examType': 'Online',
        'color': Color(0xFF00BCD4),
        'credits': 4,
        'materials': [
          'Integrasi API (RESTful)',
          'Manajemen State Lanjutan (Provider, BLoC)',
          'Penyimpanan Lokal (Shared Preferences, SQLite)',
          'Firebase Integration (Auth, Firestore)'
        ],
        'notes': 'Pengumpulan final project aplikasi mobile',
      },
      {
        'name': 'Data Mining',
        'code': '117',
        'lecturer': 'Siti Delima Sari,M.Kom',
        'date': '17 Desember 2025',
        'day': 'Rabu',
        'time': '10:00 - 11:30',
        'duration': '90 menit',
        'room': 'Lab 1',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Praktikum',
        'examType': 'Hybrid',
        'color': Color(0xFF673AB7),
        'credits': 3,
        'materials': [
          'Evaluasi Model (Confusion Matrix, ROC)',
          'Algoritma Lanjutan (SVM, Random Forest)',
          'Text Mining & Analisis Sentimen',
          'Studi Kasus Implementasi Data Mining'
        ],
        'notes': 'Presentasi hasil analisis dari dataset final project',
      },
      {
        'name': 'Etika Profesi & Bimbingan Karir',
        'code': '127',
        'lecturer': 'Riyanti Yunita K,S.Pd,M.Kom',
        'date': '18 Desember 2025',
        'day': 'Kamis',
        'time': '13:00 - 14:00',
        'duration': '60 menit',
        'room': 'Ruang 1.3',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFFE91E63),
        'credits': 2,
        'materials': [
          'Personal Branding & Portofolio Digital',
          'Strategi Negosiasi Gaji',
          'Manajemen Karir & Pengembangan Diri',
          'LinkedIn & Professional Networking'
        ],
        'notes': 'Simulasi wawancara kerja dan review portofolio',
      },
      {
        'name': 'Bahasa Indonesia',
        'code': '8',
        'lecturer': 'Uki Hares Yulianti,S.Pd,M.Pd.',
        'date': '18 Desember 2025',
        'day': 'Kamis',
        'time': '14:00 - 15:00',
        'duration': '60 menit',
        'room': 'Ruang 1.4',
        'building': 'Gedung 1',
        'floor': 'Lantai 1',
        'type': 'Teori',
        'examType': 'Offline',
        'color': Color(0xFF607D8B),
        'credits': 2,
        'materials': [
          'Penulisan Surat Resmi & Laporan',
          'Teknik Presentasi & Pidato',
          'Analisis Kesalahan Berbahasa',
          'Menulis Esai Argumentatif'
        ],
        'notes': 'Ujian praktik menulis dan presentasi singkat',
      }
    ]
  };

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

  @override
  Widget build(BuildContext context) {
    final utsCount = examSchedule['UTS']?.length ?? 0;
    final uasCount = examSchedule['UAS']?.length ?? 0;

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
                            'Jadwal Ujian',
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
                            icon: Icon(Icons.info_outline,
                                color: Color(0xFF1976D2)),
                            onPressed: () {
                              _showExamInfo();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon:
                                Icon(Icons.download, color: Color(0xFF1976D2)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Download jadwal ujian'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  color: Color(0xFF2196F3),
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$utsCount',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Mata Kuliah UTS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.assignment_turned_in,
                                  color: Color(0xFF4CAF50),
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '$uasCount',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Mata Kuliah UAS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
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
                    Tab(text: 'UTS'),
                    Tab(text: 'UAS'),
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
                      // Tab untuk UTS
                      _buildExamList('UTS'),

                      // --- PENAMBAHAN 3: Logika untuk menampilkan konten UAS ---
                      // Jika isUasAvailable bernilai true, tampilkan list jadwal UAS.
                      // Jika false, tampilkan widget placeholder.
                      isUasAvailable
                          ? _buildExamList('UAS')
                          : _buildComingSoonWidget(),
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

  // --- PENAMBAHAN 2: Widget baru untuk menampilkan pesan "Coming Soon" ---
  Widget _buildComingSoonWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: 24),
            Text(
              'Jadwal UAS Belum Tersedia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Jadwal akan ditampilkan mendekati akhir semester. Silakan cek kembali nanti.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamList(String examType) {
    final exams = examSchedule[examType] ?? [];

    // Group by date
    Map<String, List<Map<String, dynamic>>> groupedExams = {};
    for (var exam in exams) {
      final date = exam['date'];
      if (!groupedExams.containsKey(date)) {
        groupedExams[date] = [];
      }
      groupedExams[date]!.add(exam);
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: groupedExams.length,
      itemBuilder: (context, index) {
        final date = groupedExams.keys.elementAt(index);
        final examsOnDate = groupedExams[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      examsOnDate[0]['day'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${examsOnDate.length} ujian',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...examsOnDate
                .map((exam) => _buildExamCard(exam, examType))
                .toList(),
          ],
        );
      },
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam, String examType) {
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
          onTap: () => _showExamDetail(exam, examType),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 80,
                      decoration: BoxDecoration(
                        color: exam['color'],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: exam['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  exam['code'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: exam['color'],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getExamTypeColor(exam['examType'])
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getExamTypeIcon(exam['examType']),
                                      size: 12,
                                      color:
                                          _getExamTypeColor(exam['examType']),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      exam['examType'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _getExamTypeColor(
                                            exam['examType']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            exam['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                exam['time'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.timer,
                                  size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                exam['duration'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Divider(height: 1),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        exam['lecturer'],
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.room_outlined, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 6),
                    Text(
                      '${exam['room']} - ${exam['building']}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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

  Color _getExamTypeColor(String type) {
    switch (type) {
      case 'Online':
        return Color(0xFF2196F3);
      case 'Offline':
        return Color(0xFF4CAF50);
      case 'Hybrid':
        return Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  IconData _getExamTypeIcon(String type) {
    switch (type) {
      case 'Online':
        return Icons.computer;
      case 'Offline':
        return Icons.edit_note;
      case 'Hybrid':
        return Icons.hub;
      default:
        return Icons.help;
    }
  }

  void _showExamDetail(Map<String, dynamic> exam, String examType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: exam['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.assignment,
                            color: exam['color'],
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: exam['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$examType - ${exam['code']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: exam['color'],
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                exam['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Waktu & Tempat
                    _buildSectionTitle('Waktu & Tempat', Icons.event),
                    SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Tanggal',
                      '${exam['day']}, ${exam['date']}',
                      Color(0xFF2196F3),
                    ),
                    _buildDetailRow(
                      Icons.access_time,
                      'Waktu',
                      exam['time'],
                      Color(0xFF4CAF50),
                    ),
                    _buildDetailRow(
                      Icons.timer,
                      'Durasi',
                      exam['duration'],
                      Color(0xFFFF9800),
                    ),
                    _buildDetailRow(
                      Icons.room,
                      'Ruangan',
                      '${exam['room']} (${exam['floor']})',
                      Color(0xFF9C27B0),
                    ),
                    _buildDetailRow(
                      Icons.business,
                      'Gedung',
                      exam['building'],
                      Color(0xFF607D8B),
                    ),
                    SizedBox(height: 24),

                    // Info Ujian
                    _buildSectionTitle('Informasi Ujian', Icons.info),
                    SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.person,
                      'Dosen',
                      exam['lecturer'],
                      Color(0xFF2196F3),
                    ),
                    _buildDetailRow(
                      _getExamTypeIcon(exam['examType']),
                      'Tipe Ujian',
                      exam['examType'],
                      _getExamTypeColor(exam['examType']),
                    ),
                    _buildDetailRow(
                      Icons.category,
                      'Jenis',
                      exam['type'],
                      Color(0xFFE91E63),
                    ),
                    _buildDetailRow(
                      Icons.credit_card,
                      'SKS',
                      '${exam['credits']} SKS',
                      Color(0xFF3F51B5),
                    ),
                    SizedBox(height: 24),

                    // Materi Ujian
                    _buildSectionTitle('Materi Ujian', Icons.book),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: exam['materials'].map<Widget>((material) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 6),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: exam['color'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    material,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Catatan
                    _buildSectionTitle('Catatan Penting', Icons.warning),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFFF9800)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            color: Color(0xFFFF9800),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              exam['notes'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Reminder diset untuk ${exam['name']}'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: Icon(Icons.alarm),
                            label: Text('Set Reminder'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Navigasi ke ${exam['room']}'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: Icon(Icons.directions),
                            label: Text('Petunjuk'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF2196F3),
                              side: BorderSide(color: Color(0xFF2196F3)),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF2196F3)),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
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

  void _showExamInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Color(0xFF2196F3)),
            SizedBox(width: 8),
            Text('Informasi Ujian'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Periode Ujian:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• UTS: 20-23 Oktober 2025'),
              Text('• UAS: 15-18 Desember 2025'),
              SizedBox(height: 16),
              Text(
                'Ketentuan Ujian:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Hadir 15 menit sebelum ujian dimulai'),
              Text('• Bawa kartu ujian dan KTM'),
              Text('• Patuhi aturan sesuai tipe ujian'),
              Text('• Kehadiran minimal 75% untuk ikut ujian'),
              SizedBox(height: 16),
              Text(
                'Tipe Ujian:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildExamTypeInfo(
                  'Online', Color(0xFF2196F3), 'Via Google Meet/Zoom'),
              _buildExamTypeInfo('Offline', Color(0xFF4CAF50), 'Di ruang kelas'),
              _buildExamTypeInfo(
                  'Hybrid', Color(0xFFFF9800), 'Kombinasi online & offline'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildExamTypeInfo(String type, Color color, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}