import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  // Widget baru untuk membuat Info Card yang TIDAK BISA diklik
Widget _buildInfoCard({
  required IconData icon,
  required String title,
  required String content,
  required Color color,
}) {
  // Hanya menggunakan Container, tanpa InkWell
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        // Ikon panah dihapus karena ini card non-klik
      ],
    ),
  );
}

  // Fungsi generik untuk meluncurkan URL (website, tel, mailto, whatsapp, dll.)
  Future<void> _launchURL(BuildContext context, String urlString, String errorMessage) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  // Memanfaatkan _launchURL untuk WhatsApp
  Future<void> _launchWhatsApp(BuildContext context) async {
    final String url = 'https://wa.me/6281234567890?text=Halo, saya ingin bertanya mengenai informasi kampus';
    await _launchURL(context, url, "Tidak dapat membuka WhatsApp");
  }

  // Memanfaatkan _launchURL untuk Email
  Future<void> _launchEmail(BuildContext context) async {
    final String url = 'mailto:info.kampus@swu.ac.id?subject=Informasi Kampus&body=';
    await _launchURL(context, url, "Tidak dapat membuka Email");
  }

  // Memanfaatkan _launchURL untuk Telepon
  Future<void> _launchPhone(BuildContext context) async {
    final String url = 'tel:02112345678'; // Menggunakan nomor telepon dari Card Telepon
    await _launchURL(context, url, "Tidak dapat membuka Telepon");
  }

  // Fungsi untuk meluncurkan Alamat/Peta
  Future<void> _launchMap(BuildContext context) async {
    // Koordinat atau query pencarian untuk Google Maps
    final String address = 'Jl. Sunan Kalijaga, Dusun III, Berkoh, Kec. Purwokerto Selatan, Kab. Banyumas, Jawa Tengah 53146';
    final String mapUrl = 'https://www.google.com/maps/place/STMIK+Widya+Utama+Purwokerto/@-7.4395481,109.2638974,18.05z/data=!4m15!1m8!3m7!1s0x2e655c1e9cd86cad:0x2d3d7c506edb4190!2sGg.+Ramah,+Kalibakal,+Berkoh,+Kec.+Purwokerto+Sel.,+Kabupaten+Banyumas,+Jawa+Tengah+53146!3b1!8m2!3d-7.4396749!4d109.2651212!16s%2Fg%2F11bx2069zv!3m5!1s0x2e655c2373c89635:0xb03e5a4139cbea7b!8m2!3d-7.4392979!4d109.2661936!16s%2Fg%2F122091j4?entry=ttu&g_ep=EgoyMDI1MTEyMy4xIKXMDSoASAFQAw%3D%3D';
    await _launchURL(context, mapUrl, "Tidak dapat membuka Peta");
  }

  // Fungsi untuk meluncurkan Website
  Future<void> _launchWebsite(BuildContext context) async {
    final String url = 'https://swu.ac.id/';
    await _launchURL(context, url, "Tidak dapat membuka Website");
  }

  // Memanfaatkan _launchURL untuk Website Akreditasi
  Future<void> _launchAccreditationURL(BuildContext context, String programName, String url) async {
    await _launchURL(context, url, "Tidak dapat membuka laman Akreditasi $programName");
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
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Informasi Kampus',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campus Logo & Name Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2196F3),
                                Color(0xFF1976D2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF2196F3).withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.school,
                                  size: 60,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'STMIK Widya Utama',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Sekolah Tinggi Manajemen Informatika & Komputer',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Contact Section
                        Text(
                          'Hubungi Kami',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Silakan hubungi kami melalui:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),

                        // WhatsApp Contact
                        _buildContactCard(
                          context: context,
                          icon: Icons.message,
                          title: 'WhatsApp',
                          subtitle: '+62 812-3456-7890',
                          description: 'Chat langsung dengan admin kampus',
                          color: Color(0xFF25D366),
                          onTap: () => _launchWhatsApp(context),
                        ),
                        SizedBox(height: 12),

                        // Email Contact
                        _buildContactCard(
                          context: context,
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: 'info@swu.ac.id',
                          description: 'Kirim email untuk informasi lebih lanjut',
                          color: Color(0xFFE91E63),
                          onTap: () => _launchEmail(context),
                        ),
                        SizedBox(height: 12),

                        // Phone Contact
                        _buildContactCard(
                          context: context,
                          icon: Icons.phone,
                          title: 'Telepon',
                          subtitle: '(0281) 6512290',
                          description: 'Hubungi kami via telepon',
                          color: Color(0xFF2196F3),
                          onTap: () => _launchPhone(context),
                        ),
                        SizedBox(height: 24),

                        // Campus Info Section
                        Text(
                          'Informasi Kampus',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Clickable Info Card: Alamat
                        _buildClickableInfoCard(
                          context: context,
                          icon: Icons.location_on,
                          title: 'Alamat',
                          content: 'Jl. Sunan Kalijaga Berkoh\nKec. Purwokerto Selatan, Kab. Banyumas, Jawa Tengah 53146',
                          color: Color(0xFFF44336),
                          onTap: () => _launchMap(context), // <--- KLIK AKAN MEMBUKA PETA
                        ),
                        SizedBox(height: 12),

                        // Clickable Info Card: Jam Operasional
                        _buildInfoCard(
                          icon: Icons.access_time,
                          title: 'Jam Operasional',
                          content: 'Senin - Jumat: 08:00 - 16:00\nSabtu: 08:00 - 12:00\nMinggu: Tutup',
                          color: Color(0xFF4CAF50),
                        ),
                        SizedBox(height: 12),

                        // Clickable Info Card: Website
                        _buildClickableInfoCard(
                          context: context,
                          icon: Icons.language,
                          title: 'Website',
                          content: 'swu.ac.id',
                          color: Color(0xFF9C27B0),
                          onTap: () => _launchWebsite(context), // <--- KLIK AKAN MEMBUKA WEBSITE
                        ),
                        SizedBox(height: 24),

                        // Programs Section
                        Text(
                          'Program Studi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Program Studi S1 Teknik Informatika
                        _buildClickableProgramCard( // <--- Ganti ke Clickable
                          icon: Icons.computer,
                          title: 'S1 Teknik Informatika',
                          accreditation: 'Akreditasi Baik',
                          color: Color(0xFF2196F3),
                          onTap: () => _launchAccreditationURL(context, 'S1 Teknik Informatika', 'https://swu.ac.id/akreditasi/ti'),
                        ),
                        SizedBox(height: 12),

                        // Program Studi S1 Sistem Informasi
                        _buildClickableProgramCard( // <--- Ganti ke Clickable
                          icon: Icons.analytics,
                          title: 'S1 Sistem Informasi',
                          accreditation: 'Akreditasi Baik',
                          color: Color(0xFF4CAF50),
                          onTap: () => _launchAccreditationURL(context, 'S1 Sistem Informasi', 'https://swu.ac.id/akreditasi/si'),
                        ),
                        SizedBox(height: 12),

                        // Program Studi D3 Komputerisasi Akuntansi
                        _buildClickableProgramCard( // <--- Ganti ke Clickable
                          icon: Icons.desktop_windows,
                          title: 'D3 Komputerisasi Akuntansi',
                          accreditation: 'Akreditasi Baik',
                          color: Color(0xFFFF9800),
                          onTap: () => _launchAccreditationURL(context, 'D3 Komputerisasi Akuntansi', 'https://swu.ac.id/akreditasi/ka'),
                        ),
                        SizedBox(height: 24),

                        // Facilities Section
                        Text(
                          'Fasilitas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),

                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                          children: [
                            _buildFacilityCard(
                              icon: Icons.computer,
                              title: 'Lab Komputer',
                              color: Color(0xFF2196F3),
                            ),
                            _buildFacilityCard(
                              icon: Icons.wifi,
                              title: 'WiFi Gratis',
                              color: Color(0xFF4CAF50),
                            ),
                            _buildFacilityCard(
                              icon: Icons.local_library,
                              title: 'Perpustakaan',
                              color: Color(0xFF9C27B0),
                            ),
                            _buildFacilityCard(
                              icon: Icons.restaurant,
                              title: 'Kantin',
                              color: Color(0xFFFF9800),
                            ),
                            _buildFacilityCard(
                              icon: Icons.local_parking,
                              title: 'Parkir Luas',
                              color: Color(0xFF607D8B),
                            ),
                            _buildFacilityCard(
                              icon: Icons.sports_soccer,
                              title: 'Lapangan',
                              color: Color(0xFFE91E63),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Social Media Section
                        Text(
                          'Media Sosial',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialButton(
                              icon: Icons.facebook,
                              label: 'Facebook',
                              color: Color(0xFF1877F2),
                            ),
                            _buildSocialButton(
                              icon: Icons.camera_alt,
                              label: 'Instagram',
                              color: Color(0xFFE4405F),
                            ),
                            _buildSocialButton(
                              icon: Icons.play_arrow,
                              label: 'YouTube',
                              color: Color(0xFFFF0000),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Functions (Tidak Berubah kecuali _buildInfoCard diganti) ---

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  // Widget baru untuk membuat Info Card bisa diklik
  Widget _buildClickableInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required VoidCallback onTap, // <--- Menambahkan onTap
  }) {
    return InkWell( // <--- Menggunakan InkWell untuk interaksi klik
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded, // Tambahkan ikon untuk indikasi bahwa card bisa diklik
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Widget baru untuk membuat Card Program Studi yang BISA diklik
Widget _buildClickableProgramCard({
  required IconData icon,
  required String title,
  required String accreditation,
  required Color color,
  required VoidCallback onTap, // <--- Menambahkan onTap
}) {
  return InkWell( // <--- Menggunakan InkWell untuk interaksi klik
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    accreditation,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon( // <--- Tambahkan ikon panah untuk indikasi klik
            Icons.chevron_right_rounded,
            color: color,
            size: 20,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildFacilityCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}