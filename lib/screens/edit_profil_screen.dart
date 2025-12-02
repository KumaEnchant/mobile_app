import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();

  String _selectedGender = 'Laki-laki';
  bool _isLoading = false;
  bool _isInit = true; // Penanda untuk inisialisasi awal

  // -----------------------------
  // LOAD DATA (Gabungan Arguments Dashboard & SharedPreferences)
  // -----------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadInitialData();
      _isInit = false;
    }
  }

  Future<void> _loadInitialData() async {
    try {
      // 1. Ambil data yang dikirim dari Dashboard (Data API terbaru)
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      // 2. Ambil data sisanya dari Local Storage
      final prefs = await SharedPreferences.getInstance();

      if (mounted) {
        setState(() {
          // Prioritas: Gunakan data dari Dashboard dulu, jika tidak ada baru dari Prefs
          _nameController.text = args?['name'] ?? prefs.getString('name') ?? prefs.getString('auth_name') ?? '';
          _emailController.text = args?['email'] ?? prefs.getString('email') ?? prefs.getString('auth_email') ?? '';
          
          // Data ini biasanya hanya disimpan lokal
          _nimController.text = prefs.getString('nim') ?? ''; // NIM biasanya readonly dari API, tapi kita load saja
          _phoneController.text = prefs.getString('phone') ?? '';
          _addressController.text = prefs.getString('address') ?? '';
          _birthDateController.text = prefs.getString('birthDate') ?? '';
          _birthPlaceController.text = prefs.getString('birthPlace') ?? '';
          _selectedGender = prefs.getString('gender') ?? 'Laki-laki';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  // -----------------------------
  // SAVE DATA to SharedPreferences
  // -----------------------------
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Simpan data ke local storage
      await prefs.setString('name', _nameController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('nim', _nimController.text.trim());
      await prefs.setString('phone', _phoneController.text.trim());
      await prefs.setString('address', _addressController.text.trim());
      await prefs.setString('birthDate', _birthDateController.text.trim());
      await prefs.setString('birthPlace', _birthPlaceController.text.trim());
      await prefs.setString('gender', _selectedGender);

      // Update auth keys juga untuk konsistensi login session
      if (_nameController.text.isNotEmpty) {
        await prefs.setString('auth_name', _nameController.text.trim());
      }
      if (_emailController.text.isNotEmpty) {
        await prefs.setString('auth_email', _emailController.text.trim());
      }

      // Simulasi delay sedikit agar UX terasa smooth
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Profil berhasil diperbarui'),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        // PENTING: Kembali ke dashboard dengan membawa sinyal 'true'
        // Dashboard akan menangkap ini dan melakukan refresh data
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan profil: $e')),
      );
    }
  }

  // -----------------------------
  // Date Picker
  // -----------------------------
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _birthDateController.text = '${picked.day} ${_getMonthName(picked.month)} ${picked.year}';
      setState(() {});
    }
  }

  String _getMonthName(int m) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return months[m - 1];
  }

  // -----------------------------
  // UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
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
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Edit Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Picture Area
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, size: 60, color: Color(0xFF1976D2)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fitur upload foto akan segera hadir'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // FORM AREA
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Pribadi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _nameController,
                            label: 'Nama Lengkap',
                            icon: Icons.person_outline,
                            validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _nimController,
                            label: 'NIM',
                            icon: Icons.badge_outlined,
                            readOnly: true, // NIM biasanya tidak boleh diedit sembarangan
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v!.isEmpty) return 'Email tidak boleh kosong';
                              if (!v.contains('@')) return 'Email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _phoneController,
                            label: 'No. Telepon',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) => v!.isEmpty ? 'No. Telepon tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 16),

                          // Gender Radio Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                  child: Text('Jenis Kelamin', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text('Laki-laki'),
                                        value: 'Laki-laki',
                                        groupValue: _selectedGender,
                                        activeColor: const Color(0xFF2196F3),
                                        onChanged: (v) => setState(() => _selectedGender = v!),
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text('Perempuan'),
                                        value: 'Perempuan',
                                        groupValue: _selectedGender,
                                        activeColor: const Color(0xFF2196F3),
                                        onChanged: (v) => setState(() => _selectedGender = v!),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _birthPlaceController,
                            label: 'Tempat Lahir',
                            icon: Icons.location_on_outlined,
                            validator: (v) => v!.isEmpty ? 'Tempat lahir tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _birthDateController,
                            label: 'Tanggal Lahir',
                            icon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: _selectDate,
                            validator: (v) => v!.isEmpty ? 'Tanggal lahir tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            controller: _addressController,
                            label: 'Alamat Lengkap',
                            icon: Icons.home_outlined,
                            maxLines: 3,
                            validator: (v) => v!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                          ),
                          const SizedBox(height: 32),

                          // Tombol Simpan
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save),
                                        SizedBox(width: 8),
                                        Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool readOnly = false,
    bool enabled = true,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
        enabled: enabled,
        maxLines: maxLines,
        onTap: onTap,
        style: TextStyle(fontSize: 14, color: enabled ? Colors.black87 : Colors.grey[600]),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: const Color(0xFF2196F3), size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}