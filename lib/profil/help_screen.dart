import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> faqCategories = [
    {
      'title': 'Akun & Profil',
      'icon': Icons.person,
      'color': Color(0xFF2196F3),
      'faqs': [
        {
          'question': 'Bagaimana cara mengubah foto profil?',
          'answer': 'Buka menu Profil > Edit Profil > Klik icon kamera pada foto profil > Pilih foto dari galeri atau ambil foto baru.',
        },
        {
          'question': 'Bagaimana cara mengubah password?',
          'answer': 'Buka menu Profil > Ubah Password > Masukkan password lama dan password baru > Klik Simpan. Password harus minimal 8 karakter dengan kombinasi huruf besar, kecil, dan angka.',
        },
        {
          'question': 'Lupa password, apa yang harus dilakukan?',
          'answer': 'Klik "Lupa Password" di halaman login > Masukkan email terdaftar > Cek email untuk link reset password > Ikuti petunjuk untuk membuat password baru.',
        },
      ],
    },
    {
      'title': 'KRS (Kartu Rencana Studi)',
      'icon': Icons.edit_note,
      'color': Color(0xFF4CAF50),
      'faqs': [
        {
          'question': 'Bagaimana cara mengisi KRS?',
          'answer': 'Buka menu KRS > Tab "Pilih MK" > Pilih mata kuliah yang diinginkan > Pastikan total SKS tidak melebihi batas > Klik "Ajukan KRS" > Tunggu persetujuan dosen wali.',
        },
        {
          'question': 'Berapa batas maksimal SKS yang bisa diambil?',
          'answer': 'Batas maksimal SKS adalah 24 SKS per semester. Namun, batas ini dapat berbeda tergantung IPK semester sebelumnya. Mahasiswa dengan IPK ≥3.50 dapat mengambil maksimal 24 SKS.',
        },
        {
          'question': 'Kapan periode pengisian KRS?',
          'answer': 'Periode pengisian KRS biasanya dibuka 2 minggu sebelum semester baru dimulai. Informasi lengkap dapat dilihat di menu Informasi atau Pengumuman.',
        },
      ],
    },
    {
      'title': 'Jadwal Kuliah & Ujian',
      'icon': Icons.calendar_today,
      'color': Color(0xFF9C27B0),
      'faqs': [
        {
          'question': 'Bagaimana cara melihat jadwal kuliah?',
          'answer': 'Buka menu Jadwal > Pilih hari yang ingin dilihat > Klik jadwal untuk melihat detail ruangan, dosen, dan informasi lainnya.',
        },
        {
          'question': 'Apakah jadwal bisa didownload?',
          'answer': 'Ya, Anda dapat mendownload jadwal dalam format PDF. Klik icon download di pojok kanan atas halaman Jadwal.',
        },
        {
          'question': 'Bagaimana jika ada perubahan jadwal?',
          'answer': 'Perubahan jadwal akan diinformasikan melalui notifikasi push dan email. Pastikan notifikasi Anda aktif di menu Pengaturan Notifikasi.',
        },
      ],
    },
    {
      'title': 'Kehadiran',
      'icon': Icons.check_circle,
      'color': Color(0xFFFF9800),
      'faqs': [
        {
          'question': 'Berapa minimal kehadiran untuk bisa ujian?',
          'answer': 'Minimal kehadiran adalah 75% dari total pertemuan. Jika kehadiran kurang dari 75%, mahasiswa tidak diperkenankan mengikuti ujian (DO).',
        },
        {
          'question': 'Apakah izin dan sakit dihitung hadir?',
          'answer': 'Ya, izin dan sakit dengan surat keterangan resmi dihitung sebagai kehadiran. Namun, alpha tidak dihitung sebagai kehadiran.',
        },
        {
          'question': 'Bagaimana cara mengajukan izin/sakit?',
          'answer': 'Hubungi dosen pengampu mata kuliah dan submit surat keterangan ke bagian akademik maksimal 3x24 jam setelah tidak hadir.',
        },
      ],
    },
    {
      'title': 'Nilai & IPK',
      'icon': Icons.grade,
      'color': Color(0xFFF44336),
      'faqs': [
        {
          'question': 'Kapan nilai keluar?',
          'answer': 'Nilai UTS biasanya keluar 1-2 minggu setelah ujian. Nilai UAS dan nilai akhir keluar maksimal 2 minggu setelah UAS. Anda akan mendapat notifikasi saat nilai sudah tersedia.',
        },
        {
          'question': 'Bagaimana cara menghitung IPK?',
          'answer': 'IPK dihitung dengan rumus: Total (Nilai × SKS) / Total SKS. Nilai A=4.0, A-=3.7, B+=3.3, B=3.0, B-=2.7, C+=2.3, C=2.0, D=1.0, E=0.',
        },
        {
          'question': 'Apa yang harus dilakukan jika nilai tidak sesuai?',
          'answer': 'Hubungi dosen pengampu mata kuliah dalam waktu 7 hari setelah nilai keluar untuk klarifikasi. Jika masih ada masalah, ajukan sanggahan tertulis ke bagian akademik.',
        },
      ],
    },
    {
      'title': 'Pembayaran',
      'icon': Icons.payment,
      'color': Color(0xFF00BCD4),
      'faqs': [
        {
          'question': 'Bagaimana cara membayar SPP?',
          'answer': 'Pembayaran dapat dilakukan melalui transfer bank ke rekening kampus atau melalui virtual account yang tertera di tagihan. Bukti pembayaran dapat diupload melalui menu Pembayaran.',
        },
        {
          'question': 'Kapan batas waktu pembayaran?',
          'answer': 'Batas pembayaran SPP adalah tanggal 25 setiap bulannya. Keterlambatan pembayaran akan dikenakan denda sesuai ketentuan yang berlaku.',
        },
        {
          'question': 'Apa konsekuensi jika terlambat bayar?',
          'answer': 'Keterlambatan pembayaran akan dikenakan denda dan akses sistem dapat diblokir sampai pembayaran dilunasi. Hubungi bagian keuangan untuk informasi lebih lanjut.',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredFAQs {
    if (_searchQuery.isEmpty) {
      return faqCategories;
    }

    List<Map<String, dynamic>> filtered = [];
    for (var category in faqCategories) {
      List<Map<String, dynamic>> filteredQuestions = [];
      for (var faq in category['faqs']) {
        if (faq['question'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq['answer'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          filteredQuestions.add(faq);
        }
      }
      if (filteredQuestions.isNotEmpty) {
        filtered.add({
          ...category,
          'faqs': filteredQuestions,
        });
      }
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                            'Pusat Bantuan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari bantuan...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.search, color: Color(0xFF2196F3)),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Actions
              if (_searchQuery.isEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Hubungi Admin',
                          Icons.support_agent,
                          () => _showContactDialog(),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Email Support',
                          Icons.email,
                          () => _showEmailDialog(),
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
                  child: filteredFAQs.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.all(20),
                          itemCount: filteredFAQs.length,
                          itemBuilder: (context, index) {
                            final category = filteredFAQs[index];
                            return _buildCategorySection(category);
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

  Widget _buildQuickActionButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2196F3),
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 12, top: 8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: category['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                category['icon'],
                color: category['color'],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                category['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        ...List.generate(
          category['faqs'].length,
          (index) => _buildFAQCard(category['faqs'][index], category['color']),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.help_outline,
              color: color,
              size: 20,
            ),
          ),
          title: Text(
            faq['question'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          children: [
            Divider(height: 1),
            SizedBox(height: 12),
            Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coba gunakan kata kunci lain',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.support_agent, color: Color(0xFF2196F3)),
            SizedBox(width: 12),
            Text('Hubungi Admin'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactInfo(Icons.phone, 'Telepon', '(0281) 1234567'),
            SizedBox(height: 12),
            _buildContactInfo(Icons.phone_android, 'WhatsApp', '+62 812-3456-7890'),
            SizedBox(height: 12),
            _buildContactInfo(Icons.access_time, 'Jam Kerja', 'Senin-Jumat, 08:00-16:00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Membuka WhatsApp...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(Icons.chat, size: 18),
            label: Text('Chat WA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.email, color: Color(0xFF2196F3)),
            SizedBox(width: 12),
            Text('Email Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kirim email ke:',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.email, size: 20, color: Color(0xFF2196F3)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'support@stmikwidyautama.ac.id',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Atau kunjungi:',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Color(0xFF2196F3)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bagian Akademik Lt. 2\nGedung A',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Membuka email client...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: Icon(Icons.send, size: 18),
            label: Text('Kirim Email'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Color(0xFF2196F3)),
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}