import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://36.88.99.179:8000/api/';

  // ============================================================
  //                       CORE DIO CLIENT
  // ============================================================
  static Dio _getDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
      error: true,
    ));

    return dio;
  }

  static Future<Dio> _getDioWithAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
      error: true,
    ));

    return dio;
  }

  // ============================================================
  //                             AUTH
  // ============================================================

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final dio = _getDio();
      final res = await dio.post(
        "${baseUrl}auth/login",
        data: {
          "email": email.trim(),
          "password": password,
          "role": 1,
        },
      );
      return res.data;
    } on DioException catch (e) {
      return {
        'status': e.response?.statusCode ?? 500,
        'msg': e.response?.data?['msg'] ?? 'Login gagal!',
        'error': e.message,
      };
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final dio = _getDio();
      final res = await dio.post("${baseUrl}auth/register", data: data);
      return res.data;
    } on DioException catch (e) {
      return {
        'status': e.response?.statusCode ?? 500,
        'msg': e.response?.data['msg'] ?? 'Register gagal!',
      };
    }
  }

  // ============================================================
  //                           TOKEN
  // ============================================================
  static Future<void> saveToken(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
    await prefs.setString("auth_email", email);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_email");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
    await prefs.remove("auth_email");
  }

  // ============================================================
  //                       KRS BACKEND API
  // ============================================================

  static Future<Map<String, dynamic>> getAvailableCourses(int semester) async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get(
        "${baseUrl}krs/available-courses",
        queryParameters: {"semester": semester},
      );
      return res.data;
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "msg": "Gagal mengambil mata kuliah",
      };
    }
  }

  static Future<Map<String, dynamic>> saveKRS(Map<String, dynamic> data) async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.post("${baseUrl}krs/save", data: data);
      return res.data;
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "msg": "Gagal menyimpan KRS",
      };
    }
  }

  static Future<Map<String, dynamic>> finalizeKRS(Map<String, dynamic> data) async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.post("${baseUrl}krs/finalize", data: data);
      return res.data;
    } on DioException {
      return {"status": 500, "msg": "Finalisasi gagal"};
    }
  }

  static Future<Map<String, dynamic>> getCurrentKRS(int semester) async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get(
        "${baseUrl}krs/current",
        queryParameters: {"semester": semester},
      );
      return res.data;
    } on DioException {
      return {"status": 500, "msg": "Gagal mengambil current KRS"};
    }
  }

  static Future<Map<String, dynamic>> getKRSStatus() async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get("${baseUrl}krs/status");
      return res.data;
    } on DioException {
      return {"status": 500, "msg": "Gagal mengambil status"};
    }
  }

  // ============================================================
  //                     INSTANCE METHODS (NEW API)
  // ============================================================

  // ---- GET ALL COURSES CLEAN LIST ----
  Future<List<Map<String, dynamic>>> getCourses({required int semester}) async {
    try {
      final dio = await ApiService._getDioWithAuth();
      final res = await dio.get(
        "${ApiService.baseUrl}courses",
        queryParameters: {"semester": semester},
      );

      if (res.statusCode == 200 && res.data is List) {
        // ✅ FIXED: Proper type casting
        return (res.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      print("ERROR getCourses: $e");
      return [];
    }
  }

  // ---- GET KRS HISTORY WITH NIM ----
  Future<List<Map<String, dynamic>>> getKRSHistory({required String nim}) async {
    try {
      final dio = await ApiService._getDioWithAuth();
      final res = await dio.get(
        "${ApiService.baseUrl}krs/history-by-nim",
        queryParameters: {"nim": nim},
      );

      if (res.data is List) {
        // ✅ FIXED: Proper type casting
        return (res.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }

      return [];
    } catch (e) {
      print("ERROR getKRSHistory: $e");
      return [];
    }
  }

  // ---- ADD COURSE ----
  Future<bool> addKRS({
    required String nim,
    required String courseCode,
    required int semester,
  }) async {
    try {
      final dio = await ApiService._getDioWithAuth();
      final res = await dio.post(
        "${ApiService.baseUrl}krs/add",
        data: {
          "nim": nim,
          "course_code": courseCode,
          "semester": semester,
        },
      );
      return res.data["status"] == true;
    } catch (e) {
      print("ERROR addKRS: $e");
      return false;
    }
  }

  // ---- REMOVE COURSE ----
  Future<bool> removeKRS({
    required String nim,
    required String courseCode,
    required int semester,
  }) async {
    try {
      final dio = await ApiService._getDioWithAuth();
      final res = await dio.post(
        "${ApiService.baseUrl}krs/remove",
        data: {
          "nim": nim,
          "course_code": courseCode,
          "semester": semester,
        },
      );
      return res.data["status"] == true;
    } catch (e) {
      print("ERROR removeKRS: $e");
      return false;
    }
  }

  // ============================================================
  //                     COMPATIBILITY LAYER
  // ============================================================

  // Versi lama: fetch riwayat (tanpa nim) - STATIC
  static Future<List<Map<String, dynamic>>> fetchKRSHistory() async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get("${baseUrl}krs/history");
      
      if (res.data is List) {
        // ✅ FIXED: Proper type casting
        return (res.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      print("ERROR fetchKRSHistory: $e");
      return [];
    }
  }

  // Versi lama: get KRS history tanpa parameter - STATIC
  static Future<Map<String, dynamic>> getKRSHistoryOld() async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get("${baseUrl}krs/history");
      return res.data;
    } on DioException {
      return {"status": 500, "msg": "Gagal mengambil riwayat"};
    }
  }

  // ============================================================
  //                   ABSENSI / KEHADIRAN API
  // ============================================================

  /// Submit absensi dengan foto & lokasi
  /// endpoint: POST /api/absensi/submit
  /// body: {id_krs_detail, pertemuan, latitude, longitude, foto (multipart)}
  static Future<Map<String, dynamic>> submitAbsensi({
    required int idKrsDetail,
    required int pertemuan,
    required double latitude,
    required double longitude,
    required MultipartFile foto,
  }) async {
    try {
      final dio = await _getDioWithAuth();
      
      final formData = FormData.fromMap({
        "id_krs_detail": idKrsDetail,
        "pertemuan": pertemuan,
        "latitude": latitude,
        "longitude": longitude,
        "foto": foto,
      });

      final res = await dio.post(
        "${baseUrl}absensi/submit",
        data: formData,
      );

      return res.data;
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "msg": e.response?.data?["msg"] ?? "Gagal submit absensi",
        "error": e.message,
      };
    }
  }

  /// Get detail absensi per pertemuan
  /// endpoint: GET /api/absensi/detail?id_krs_detail=x&pertemuan=y
  static Future<Map<String, dynamic>> getDetailAbsensi({
    required int idKrsDetail,
    required int pertemuan,
  }) async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get(
        "${baseUrl}absensi/detail",
        queryParameters: {
          "id_krs_detail": idKrsDetail,
          "pertemuan": pertemuan,
        },
      );
      return res.data;
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "msg": "Gagal mengambil detail absensi",
        "data": null,
      };
    }
  }

  /// Get status absensi untuk semua pertemuan (1-16) sebuah mata kuliah
  /// endpoint: GET /api/absensi/status?id_krs_detail=x
  /// Return: List<Map> data status per pertemuan
  static Future<List<Map<String, dynamic>>> getStatusAbsensi({
    required int idKrsDetail,
  }) async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get(
        "${baseUrl}absensi/status",
        queryParameters: {"id_krs_detail": idKrsDetail},
      );
      
      // ✅ FIXED: Parse response properly
      if (res.data is List) {
        return (res.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }
      
      // Kalau wrapped di 'data' key
      if (res.data is Map && res.data.containsKey('data')) {
        final data = res.data['data'];
        if (data is List) {
          return (data as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print("ERROR getStatusAbsensi: $e");
      return [];
    }
  }

  /// Get ringkasan kehadiran mahasiswa (total hadir/alpha/izin/sakit)
  /// endpoint: GET /api/absensi/summary
  /// Return: List<Map> ringkasan per mata kuliah
  static Future<List<Map<String, dynamic>>> getSummaryAbsensi() async {
    try {
      final dio = await _getDioWithAuth();
      final res = await dio.get("${baseUrl}absensi/summary");
      
      // ✅ FIXED: Parse response properly
      if (res.data is List) {
        return (res.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }
      
      // Kalau wrapped di 'data' key
      if (res.data is Map && res.data.containsKey('data')) {
        final data = res.data['data'];
        if (data is List) {
          return (data as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print("ERROR getSummaryAbsensi: $e");
      return [];
    }
  }

  /// Get semua data kehadiran mahasiswa (untuk halaman kehadiran)
  /// endpoint: GET /api/absensi/kehadiran
  /// Return: List<Map> data kehadiran per mata kuliah
  static Future<List<Map<String, dynamic>>> getKehadiranMahasiswa() async {
    try {
      final dio = await _getDioWithAuth();
      // Pastikan URL ini sesuai dengan route di Laravel/Backend kamu
      final res = await dio.get("${baseUrl}absensi/kehadiran");
      
      // LOG UNTUK DEBUGGING (Cek di console outputnya apa)
      print("📥 API RESPONSE KEHADIRAN: ${res.data}");

      // SKENARIO 1: Response langsung berupa List [ {...}, {...} ]
      if (res.data is List) {
        return (res.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      }
      
      // SKENARIO 2: Response dibungkus object { "data": [...] }
      if (res.data is Map && res.data.containsKey('data')) {
        final data = res.data['data'];
        if (data is List) {
          return (data as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print("❌ ERROR getKehadiranMahasiswa: ${e.response?.statusCode} - ${e.message}");
      return [];
    }
  }

  /// Submit izin/sakit (dengan surat keterangan)
  /// endpoint: POST /api/absensi/submit-izin
  /// body: {id_krs_detail, pertemuan, tipe (izin/sakit), surat_keterangan (file)}
  static Future<Map<String, dynamic>> submitIzinSakit({
    required int idKrsDetail,
    required int pertemuan,
    required String tipe, // "izin" atau "sakit"
    required MultipartFile suratKeterangan,
    String? keterangan,
  }) async {
    try {
      final dio = await _getDioWithAuth();
      
      final formData = FormData.fromMap({
        "id_krs_detail": idKrsDetail,
        "pertemuan": pertemuan,
        "tipe": tipe,
        "surat_keterangan": suratKeterangan,
        if (keterangan != null) "keterangan": keterangan,
      });

      final res = await dio.post(
        "${baseUrl}absensi/submit-izin",
        data: formData,
      );

      return res.data;
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "msg": e.response?.data?["msg"] ?? "Gagal submit izin/sakit",
        "error": e.message,
      };
    }
  }
}