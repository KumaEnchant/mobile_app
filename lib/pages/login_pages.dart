import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:siakad/pages/dashboard_pages.dart';
import '../api/api_service.dart';
import 'register_pages.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> doLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🔸 Validasi input kosong
    if (email.isEmpty || password.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Perhatian',
        text: 'Email dan password tidak boleh kosong!',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      print('🔹 Mengirim request login...');
      final res = await ApiService.login(email, password);
      print('🔹 Response login: $res');

      // 🔸 Tangani error bawaan API / koneksi
      if (res.containsKey('error')) {
        throw Exception(res['error']);
      }

      // 🔸 Cek status atau struktur respons
      final status = res['status'];
      final success = res['success'] ?? false;
      final data = res['data'];

      if (status == 200 || success == true) {
        // 🔸 Ambil token (bisa nested map)
        final token = (data is Map && data.containsKey('token'))
            ? data['token']
            : data.toString();

        await ApiService.saveToken(token, email);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: 'Login Berhasil!',
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPages()),
            );
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal Login',
          text: 'Email atau password salah!',
        );
      }
    } catch (e) {
      print('❌ Login Error: $e');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Terjadi Kesalahan',
        text: 'Tidak dapat terhubung ke server. Pastikan API aktif.',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : doLogin,
                  child: Text(isLoading ? 'Loading...' : 'Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPages()),
                    );
                  },
                  child: const Text("Belum Punya Akun? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
