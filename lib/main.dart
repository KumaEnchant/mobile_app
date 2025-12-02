import 'package:flutter/material.dart';

// Import logic dari SIAKAD (penting!)
import 'package:siakad/api/api_service.dart';

// Import semua screen
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/information_screen.dart';
import 'screens/krs_screen.dart';
import 'screens/jadwal_screen.dart';
import 'screens/khs_screen.dart';
import 'screens/kehadiran_screen.dart';
import 'screens/jadwal_ujian_screen.dart';
import 'profil/edit_profile_screen.dart';
import 'profil/change_password_screen.dart';
import 'profil/notification_screen.dart';
import 'profil/help_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIAKAD Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
      ),

      // AuthWrapper menentukan apakah ke Login atau Dashboard
      home: const AuthWrapper(),

      // routes navigasi
      routes: {
        // PERBAIKAN: Hapus 'const' di sini karena widget ini mungkin berubah
        // atau membutuhkan parameter di masa depan.
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/otp": (context) => OTPScreen(),
        "/dashboard": (context) => DashboardScreen(),
        "/information": (context) => InformationScreen(),
        "/krs": (context) => KRSScreen(),
        "/jadwal": (context) => JadwalScreen(),
        "/khs": (context) => KHSScreen(),
        "/kehadiran": (context) => KehadiranScreen(),
        "/jadwal-ujian": (context) => JadwalUjianScreen(), // Ini yang tadi error
        "/edit-profile": (context) => EditProfileScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/notification': (context) => NotificationScreen(),
        '/help': (context) => HelpScreen(),
      },
    );
  }
}

// WIDGET CEK LOGIN
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ApiService.getToken(), // Cek token di storage
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Jika ada token (User sudah login)
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        } else {
          // Jika tidak ada token (Belum login)
          return const LoginScreen();
        }
      },
    );
  }
}