import 'package:flutter/material.dart';

class KHSScreen extends StatefulWidget {
  const KHSScreen({super.key});

  @override
  State<KHSScreen> createState() => _KHSScreenState();
}

class _KHSScreenState extends State<KHSScreen> {
  int selectedSemester = 5;

  final Color primaryColor = Color(0xFF2196F3);
  final Color primaryColorDark = Color(0xFF1976D2);

  // Data Dummy KHS
  final Map<int, Map<String, dynamic>> khsData = {
    1: {
      'semester': 'Semester 1',
      'year': 'Ganjil 2023/2024',
      'ips': 3.73,
      'ipk': 3.73,
      'totalSks': 22,
      'sksTempuh': 22,
      'courses': [
        {'code': 'STI110122001', 'name': 'MATEMATIKA DISKRIT', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110122006', 'name': 'ADMINISTRASI BISNIS', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110122005', 'name': 'ENGLISH', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110122007', 'name': 'KALKULUS', 'credits': 2, 'grade': 'B', 'quality': 3.0},
        {'code': 'STI110122002', 'name': 'ALGORITMA', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110122009', 'name': 'DESAIN GRAFIS', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110122003', 'name': 'PENGANTAR TEKNOLOGI INFORMASI', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110122004', 'name': 'MANAJEMEN', 'credits': 2, 'grade': 'B', 'quality': 3.0},
        {'code': 'STI110122008', 'name': 'BAHASA ASING', 'credits': 2, 'grade': 'B', 'quality': 3.0},
      ],
    },
    2: {
      'semester': 'Semester 2',
      'year': 'Genap 2023/2024',
      'ips': 3.81,
      'ipk': 3.77,
      'totalSks': 43,
      'sksTempuh': 21,
      'courses': [
        {'code': 'STI110222002', 'name': 'ENGLISH 2', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI102BS06', 'name': 'INTERAKSI MANUSIA DAN KOMPUTER', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI102BS09', 'name': 'SISTEM BERKAS', 'credits': 2, 'grade': 'B', 'quality': 3.0},
        {'code': 'STI104BS05', 'name': 'STATISTIKA DAN PROBABILITAS', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI102BS03', 'name': 'SISTEM BASIS DATA', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI102BS04', 'name': 'KOMUNIKASI DATA', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI101BS10', 'name': 'METODE NUMERIK', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI102BS10', 'name': 'SISTEM OPERASI', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110222001', 'name': 'BAHASA JEPANG 2', 'credits': 2, 'grade': 'B', 'quality': 3.0},
      ],
    },
    3: {
      'semester': 'Semester 3',
      'year': 'Ganjil 2024/2025',
      'ips': 3.74,
      'ipk': 3.76,
      'totalSks': 66,
      'sksTempuh': 23,
      'courses': [
        {'code': 'STI1103002', 'name': 'DESKTOP PROGRAMMING', 'credits': 4, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI1103003', 'name': 'JARINGAN KOMPUTER', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI1103001', 'name': 'KEWIRAUSAHAAN', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI1103004', 'name': 'KONSEP PERANGKAT KERAS', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI1103007', 'name': 'LOGIKA FUZZY', 'credits': 2, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI1103005', 'name': 'SISTEM INFORMASI MANAJEMEN', 'credits': 2, 'grade': 'B', 'quality': 3.0},
        {'code': 'STI1103006', 'name': 'TEORI BAHASA DAN AUTOMATA', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI1103008', 'name': 'WEB PROGRAMMING', 'credits': 4, 'grade': 'B', 'quality': 3.0},
      ],
    },
    4: {
      'semester': 'Semester 4',
      'year': 'Genap 2024/2025',
      'ips': 3.88,
      'ipk': 3.79,
      'totalSks': 90,
      'sksTempuh': 24,
      'courses': [
        {'code': 'STI104BS02', 'name': 'REKAYASA PERANGKAT KERAS', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI104BS03', 'name': 'ARSITEK DAN ORGANISASI KOMPUTER', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110425001', 'name': 'SISTEM PENUNJANG KEPUTUSAN', 'credits': 3, 'grade': 'B', 'quality': 3.0},
        {'code': 'STI104BS04', 'name': 'SISTEM BASIS DATA LANJUT', 'credits': 4, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI110425002', 'name': 'PEMROGRAMAN BAHASA RAKITAN', 'credits': 4, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI104BS06', 'name': 'KRIPTOGRAFI', 'credits': 3, 'grade': 'A', 'quality': 4.0},
        {'code': 'STI104BS01', 'name': 'PEMROGRAMAN BERORIENTASI OBJEK', 'credits': 4, 'grade': 'A', 'quality': 4.0},
      ],
    },
    5: {
      'semester': 'Semester 5',
      'year': 'Ganjil 2025/2026',
      'ips': 0.00,
      'ipk': 3.79,
      'totalSks': 114,
      'sksTempuh': 24,
      'courses': [
        {'code': 'STI11052401', 'name': 'KEWARGANEGARAAN', 'credits': 2, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052403', 'name': 'MANAJEMEN BISNIS', 'credits': 2, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052402', 'name': 'AGAMA', 'credits': 2, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052407', 'name': 'RANGKAIAN DIGITAL', 'credits': 3, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052405', 'name': 'TECHNOPRENEURSHIP', 'credits': 2, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052410', 'name': 'MOBILE PROGRAMMING', 'credits': 4, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052409', 'name': 'DATA MINING', 'credits': 3, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052404', 'name': 'PANCASILA', 'credits': 2, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052406', 'name': 'ETIKA PROFESI DAN BIMBINGAN KARIR', 'credits': 2, 'grade': '-', 'quality': 0.0},
        {'code': 'STI11052408', 'name': 'BAHASA INDONESIA', 'credits': 2, 'grade': '-', 'quality': 0.0},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    // 1. TERIMA DATA DARI DASHBOARD
    final Map<String, dynamic>? userArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String displayName = userArgs?['nama']?.toString() ?? 'Mahasiswa';
    final String displayNim = userArgs?['nim']?.toString() ?? '-';

    final Map<String, dynamic> summaryKHS = khsData[4]!;
    final Map<String, dynamic> currentKHS = khsData[selectedSemester]!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [primaryColor, primaryColorDark],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, displayName, displayNim),
              _buildIPKCard(summaryKHS, currentKHS),
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
                    children: [
                      SizedBox(height: 10), // Jarak sedikit dari lengkungan
                      _buildSemesterSelector(),
                      SizedBox(height: 5), // Jarak aman biar gak nempel
                      Expanded(child: _buildCoursesList(currentKHS)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // 2. HEADER DINAMIS (Nama & NIM)
  Widget _buildHeader(BuildContext context, String nama, String nim) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColorDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kartu Hasil Studi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  nama,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  nim,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.download, color: primaryColorDark),
              onPressed: () {
                _showDownloadDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIPKCard(Map<String, dynamic> summaryKHS, Map<String, dynamic> currentKHS) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIPKItem(
                'IPK',
                summaryKHS['ipk'].toStringAsFixed(2),
                Color(0xFF4CAF50),
                Icons.trending_up,
              ),
              Container(height: 60, width: 1, color: Colors.grey[300]),
              _buildIPKItem(
                'IPS',
                currentKHS['ips'] == 0.00
                    ? '---'
                    : currentKHS['ips'].toStringAsFixed(2),
                Color(0xFF2196F3),
                Icons.star,
              ),
              Container(height: 60, width: 1, color: Colors.grey[300]),
              _buildIPKItem(
                'Total SKS',
                summaryKHS['totalSks'].toString(),
                Color(0xFF9C27B0),
                Icons.credit_card,
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Semester Aktif', '5 Ganjil'),
              _buildStatItem('SKS Semester Ini', '${currentKHS['sksTempuh']} SKS'),
              _buildStatItem('Status', 'Aktif'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIPKItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 3. SEMESTER SELECTOR (Sudah di-fix: Tinggi, Clip, Padding)
  Widget _buildSemesterSelector() {
    return Container(
      height: 80, // Tinggi ditambah biar shadow aman
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // Penting: Biar shadow gak kepotong
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemCount: khsData.length,
        itemBuilder: (context, index) {
          final semester = index + 1;
          final isSelected = semester == selectedSemester;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSemester = semester;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? primaryColorDark : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? primaryColorDark : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColorDark.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
              ),
              child: Center(
                child: Text(
                  'Smt $semester',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoursesList(Map<String, dynamic> khs) {
    final courses = khs['courses'] as List<Map<String, dynamic>>;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${khs['semester']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${khs['year']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${courses.length} Mata Kuliah',
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
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: courses.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final course = courses[index];
              return _buildCourseCard(course);
            },
          ),
          SizedBox(height: 16),
          _buildSummaryCard(khs),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final bool isCurrentSemester = course['grade'] == '-';
    Color gradeColor;

    if (isCurrentSemester) {
      gradeColor = Colors.grey;
    } else if (course['grade'].startsWith('A')) {
      gradeColor = Color(0xFF4CAF50);
    } else if (course['grade'].startsWith('B')) {
      gradeColor = Color(0xFF2196F3);
    } else if (course['grade'].startsWith('C')) {
      gradeColor = Color(0xFFFF9800);
    } else {
      gradeColor = Color(0xFFF44336);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
        onTap: () {
          if (!isCurrentSemester) {
            _showCourseDetailDialog(course);
          }
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isCurrentSemester
                      ? Icon(Icons.schedule, color: gradeColor, size: 24)
                      : Text(
                          course['grade'],
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
                      course['code'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      course['name'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildCourseInfo(Icons.credit_card, '${course['credits']} SKS'),
                        if (!isCurrentSemester) ...[
                          SizedBox(width: 16),
                          _buildCourseInfo(Icons.star, 'Bobot: ${course['quality']}'),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
              if (!isCurrentSemester)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> khs) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Semester',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 12),
          _buildSummaryRow('SKS Diambil', '${khs['sksTempuh']} SKS'),
          SizedBox(height: 10),
          _buildSummaryRow(
            'IP Semester',
            khs['ips'] == 0.00 ? '---' : khs['ips'].toStringAsFixed(2),
          ),
          SizedBox(height: 10),
          _buildSummaryRow('IPK Kumulatif', khs['ipk'].toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _showGradeStatistics(context);
                },
                icon: Icon(Icons.show_chart), // Icon Chart
                label: Text('Statistik'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: primaryColorDark),
                  foregroundColor: primaryColorDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showDownloadDialog(context);
                },
                icon: Icon(Icons.download),
                label: Text('Cetak'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColorDark,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseDetailDialog(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Detail Nilai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kode', course['code']),
            Divider(),
            _buildDetailRow('Mata Kuliah', course['name']),
            Divider(),
            _buildDetailRow('SKS', '${course['credits']}'),
            Divider(),
            _buildDetailRow('Nilai Huruf', course['grade']),
            Divider(),
            _buildDetailRow('Bobot', '${course['quality']}'),
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
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.download, color: primaryColor),
            SizedBox(width: 8),
            Text('Download Transkrip'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: primaryColorDark),
              title: Text('Download PDF'),
              subtitle: Text('Transkrip dalam format PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mengunduh transkrip PDF...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart, color: Color(0xFF4CAF50)),
              title: Text('Download Excel'),
              subtitle: Text('Transkrip dalam format Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mengunduh transkrip Excel...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  // 4. LOGIKA POPUP CHART STATISTIK
  void _showGradeStatistics(BuildContext context) {
    // Siapkan data untuk Grafik
    List<double> ipsHistory = [];
    List<String> labels = [];

    // Ambil history IPS
    khsData.forEach((key, value) {
      if ((value['ips'] as num) > 0) { // Hanya ambil semester yg sudah ada nilai
        ipsHistory.add((value['ips'] as num).toDouble());
        labels.add('S$key');
      }
    });

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.show_chart, color: primaryColor),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Statistik Akademik',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text("Grafik Perkembangan IPS", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              // --- AREA GRAFIK ---
              Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.only(top: 10, right: 10),
                child: CustomPaint(
                  painter: IPSChartPainter(
                    scores: ipsHistory,
                    labels: labels,
                    lineColor: primaryColor,
                  ),
                ),
              ),
              // -------------------

              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tutup"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 5. CLASS PAINTER UNTUK MENGGAMBAR GRAFIK
class IPSChartPainter extends CustomPainter {
  final List<double> scores;
  final List<String> labels;
  final Color lineColor;

  IPSChartPainter({
    required this.scores,
    required this.labels,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final Paint dotPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final Paint dotBorderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    final double maxScore = 4.0;
    final double chartHeight = size.height - 30;
    final double stepX = size.width / (scores.length > 1 ? scores.length - 1 : 1);

    // Gambar Garis Grid & Label Y
    for (int i = 0; i <= 4; i++) {
      double y = chartHeight - (i * (chartHeight / 4));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      TextSpan span = TextSpan(style: TextStyle(color: Colors.grey, fontSize: 10), text: i.toString());
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(-15, y - 6));
    }

    if (scores.isEmpty) return;

    // Path untuk garis grafik
    final Path path = Path();
    List<Offset> points = [];

    for (int i = 0; i < scores.length; i++) {
      double x = i * stepX;
      double y = chartHeight - ((scores[i] / maxScore) * chartHeight);

      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Label X Axis (Semester)
      TextSpan span = TextSpan(
        style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold),
        text: labels[i]
      );
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(x - (tp.width / 2), chartHeight + 10));
    }

    // Gambar Garis
    canvas.drawPath(path, linePaint);

    // Gambar Titik Data
    for (var point in points) {
      canvas.drawCircle(point, 6, dotPaint);
      canvas.drawCircle(point, 6, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 