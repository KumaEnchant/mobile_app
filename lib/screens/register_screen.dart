import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import '../api/api_service.dart'; // Sesuaikan path

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _tglLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _idTahunController = TextEditingController();
  
  // State variables
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  String? _jenisKelamin;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _tglLahirController.dispose();
    _alamatController.dispose();
    _angkatanController.dispose();
    _idTahunController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool isPassword = false,
    bool isConfirmPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                icon,
                color: Colors.grey[600],
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          if (isConfirmPassword) {
                            _isObscureConfirm = !_isObscureConfirm;
                          } else {
                            _isObscure = !_isObscure;
                          }
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Color(0xFF1976D2),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1999),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _tglLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _registerAct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Ambil semua data dari controller
      final data = {
        'nama': _nameController.text,
        'tgl_lahir': _tglLahirController.text,
        'jenis_kelamin': _jenisKelamin,
        'alamat': _alamatController.text,
        'angkatan': _angkatanController.text,
        'id_tahun': _idTahunController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      // === DEBUG LOG ===
      print('======================');
      print('=== REGISTER DATA ===');
      print('======================');
      print('Data yang dikirim:');
      print('Nama: ${data['nama']}');
      print('Email: ${data['email']}');
      print('Tanggal Lahir: ${data['tgl_lahir']}');
      print('Jenis Kelamin: ${data['jenis_kelamin']}');
      print('Alamat: ${data['alamat']}');
      print('Angkatan: ${data['angkatan']}');
      print('ID Tahun: ${data['id_tahun']}');
      print('Password: ${data['password']}');
      print('======================');
      // === END DEBUG ===

      try {
        // Panggil ApiService.register
        final response = await ApiService.register(data);

        // === DEBUG LOG ===
        print('');
        print('======================');
        print('=== REGISTER RESPONSE ===');
        print('======================');
        print('Full Response: $response');
        print('Response Type: ${response.runtimeType}');
        print('Status: ${response['status']}');
        print('Status Type: ${response['status'].runtimeType}');
        print('Message: ${response['message']}');
        print('Data: ${response['data']}');
        print('======================');
        // === END DEBUG ===

        // Cek status bisa int atau string
        bool isSuccess = false;
        if (response['status'] is int) {
          isSuccess = response['status'] == 200 || response['status'] == 201;
        } else if (response['status'] is String) {
          isSuccess = response['status'].toString().toLowerCase() == 'success';
        }

        if (isSuccess) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Registrasi Berhasil',
            onConfirmBtnTap: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to login screen
            },
          );
        } else {
          // Tampilkan error dari server
          String errorMsg = 'Registrasi Gagal';
          
          if (response['message'] != null) {
            errorMsg = response['message'].toString();
          } else if (response['msg'] != null) {
            errorMsg = response['msg'].toString();
          } else if (response['error'] != null) {
            errorMsg = response['error'].toString();
          }
          
          print('Error Message: $errorMsg');
          
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: errorMsg,
          );
        }
      } catch (e, stackTrace) {
        // === DEBUG LOG ===
        print('');
        print('======================');
        print('=== ERROR REGISTER ===');
        print('======================');
        print('Error: $e');
        print('Error Type: ${e.runtimeType}');
        print('StackTrace: $stackTrace');
        print('======================');
        // === END DEBUG ===
        
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Terjadi kesalahan: $e',
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
              Color(0xFF0D47A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                      'Daftar Akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // Logo
                        Container(
                          width: 80,
                          height: 80,
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
                          child: Center(
                            child: Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 40,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Buat Akun Baru',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Nama
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nama Lengkap*',
                          hint: 'Masukkan nama lengkap...',
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          validator: (value) =>
                              value!.isEmpty ? "Nama tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 20),

                        // Email
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email*',
                          hint: 'Masukkan email...',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            if (!value.contains('@')) {
                              return "Email tidak valid";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Tanggal Lahir
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                'Tanggal Lahir*',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _tglLahirController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Pilih tanggal...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey[600],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Color(0xFF1976D2),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                                onTap: _pilihTanggal,
                                validator: (v) =>
                                    v!.isEmpty ? "Tanggal lahir wajib diisi" : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Jenis Kelamin
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                'Jenis Kelamin*',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                  filled: false,
                                  prefixIcon: Icon(
                                    Icons.wc,
                                    color: Colors.grey[600],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 18,
                                  ),
                                ),
                                value: _jenisKelamin,
                                hint: Text(
                                  'Pilih jenis kelamin...',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "L",
                                    child: Text("Laki-laki"),
                                  ),
                                  DropdownMenuItem(
                                    value: "P",
                                    child: Text("Perempuan"),
                                  ),
                                ],
                                onChanged: (value) =>
                                    setState(() => _jenisKelamin = value),
                                validator: (v) =>
                                    v == null ? "Pilih jenis kelamin" : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Alamat
                        _buildTextField(
                          controller: _alamatController,
                          label: 'Alamat*',
                          hint: 'Masukkan alamat...',
                          icon: Icons.home_outlined,
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 20),

                        // Angkatan
                        _buildTextField(
                          controller: _angkatanController,
                          label: 'Angkatan*',
                          hint: 'Contoh: 2023',
                          icon: Icons.numbers_outlined,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "Angkatan tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 20),

                        // Tahun Masuk
                        _buildTextField(
                          controller: _idTahunController,
                          label: 'Tahun Masuk*',
                          hint: 'Contoh: 2023',
                          icon: Icons.numbers,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? "Tahun Masuk tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 20),

                        // Password
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password*',
                          hint: 'Masukkan password...',
                          icon: Icons.lock_outline,
                          obscureText: _isObscure,
                          isPassword: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.length < 6) {
                              return "Password minimal 6 karakter";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Konfirmasi Password
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Konfirmasi Password*',
                          hint: 'Masukkan ulang password...',
                          icon: Icons.lock_outline,
                          obscureText: _isObscureConfirm,
                          isPassword: true,
                          isConfirmPassword: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Konfirmasi password wajib diisi";
                            }
                            if (value != _passwordController.text) {
                              return "Password tidak sesuai";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 36),

                        // Register Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _registerAct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0D47A1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah punya akun? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 15,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
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
}