import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickalert/quickalert.dart';

import '../helpers/webcam_helper.dart';
import '../api/api_service.dart';

class AbsenSubmitScreen extends StatefulWidget {
  final int idKrsDetail;
  final int pertemuan;
  final String namaMatkul;
  final String topic;

  const AbsenSubmitScreen({
    super.key,
    required this.idKrsDetail,
    required this.pertemuan,
    required this.namaMatkul,
    required this.topic,
  });

  @override
  State<AbsenSubmitScreen> createState() => _AbsenSubmitScreenState();
}

class _AbsenSubmitScreenState extends State<AbsenSubmitScreen> {
  final WebCamera cam = WebCamera();
  Uint8List? imageBytes;
  Position? position;
  bool isCameraReady = false;
  bool isSubmitting = false;
  bool showingCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCameraAfterRender();
    });
    _getLocation();
  }

  Future<void> _initializeCameraAfterRender() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await cam.initialize();
      
      // ✅ Setup callbacks
      cam.onCapture = _capturePhoto;
      cam.onCancel = _cancelCamera;
      
      if (mounted) setState(() => isCameraReady = true);
    } catch (e) {
      debugPrint("❌ Error init camera: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal akses kamera: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    cam.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    if (!isCameraReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera belum siap")),
      );
      return;
    }

    setState(() => showingCamera = true);
    await Future.delayed(const Duration(milliseconds: 100));
    cam.showPreview();
  }

  Future<void> _capturePhoto() async {
    try {
      final data = await cam.capture();
      cam.hidePreview();
      
      setState(() {
        imageBytes = data;
        showingCamera = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Foto berhasil diambil!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error capture: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengambil foto: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cancelCamera() async {
    cam.hidePreview();
    setState(() => showingCamera = false);
  }

  Future<void> _getLocation() async {
    try {
      bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        throw "Layanan lokasi tidak aktif. Mohon nyalakan GPS.";
      }

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        throw "Izin lokasi ditolak permanen. Buka pengaturan browser untuk mengizinkan.";
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (mounted) {
        setState(() => position = pos);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ Lokasi diambil! Akurasi: ${pos.accuracy.toStringAsFixed(1)}m"
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error get location: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitAbsen() async {
    if (imageBytes == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Foto Kosong',
        text: 'Harap ambil foto terlebih dahulu',
      );
      return;
    }
    if (position == null) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Lokasi Kosong',
        text: 'Sedang mengambil lokasi, harap tunggu...',
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      debugPrint("📤 SENDING DATA:");
      debugPrint("  - id_krs_detail: ${widget.idKrsDetail}");
      debugPrint("  - pertemuan: ${widget.pertemuan}");
      debugPrint("  - latitude: ${position!.latitude}");
      debugPrint("  - longitude: ${position!.longitude}");
      debugPrint("  - foto size: ${imageBytes!.length} bytes");

      Dio dio = Dio();

      final form = FormData.fromMap({
        "id_krs_detail": widget.idKrsDetail.toString(),
        "pertemuan": widget.pertemuan.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
        "foto": await MultipartFile.fromBytes(
          imageBytes!,
          filename: "absen_${DateTime.now().millisecondsSinceEpoch}.png",
          contentType: DioMediaType('image', 'png'),
        ),
      });

      debugPrint("🌐 POST to: ${ApiService.baseUrl}absensi/submit");

      final res = await dio.post(
        "${ApiService.baseUrl}absensi/submit",
        data: form,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint("📥 RESPONSE STATUS: ${res.statusCode}");
      debugPrint("📥 RESPONSE DATA: ${res.data}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (mounted) {
          // ✅ Show success dialog
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Berhasil',
            text: res.data["message"] ?? "Absen berhasil tercatat",
            barrierDismissible: false,
          );
          
          // ✅ KUNCI: Pop dengan return TRUE agar KehadiranScreen tahu berhasil
          if (mounted) {
            Navigator.pop(context, true); // ← INI YANG PENTING!
          }
        }
      } else {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          error: res.data["message"] ?? "Error ${res.statusCode}",
        );
      }
    } on DioException catch (e) {
      debugPrint("❌ DioException: ${e.type}");
      debugPrint("❌ Error: ${e.error}");
      debugPrint("❌ Response: ${e.response?.data}");
      
      String errorMsg = "Gagal submit absen";
      
      if (e.response != null) {
        if (e.response!.data is Map && e.response!.data["message"] != null) {
          errorMsg = e.response!.data["message"];
        } else {
          errorMsg = "Error ${e.response!.statusCode}: ${e.response!.statusMessage}";
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = "Koneksi timeout, coba lagi";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = "Server tidak merespon";
      } else if (e.type == DioExceptionType.badResponse) {
        errorMsg = "Server menolak request";
      } else {
        errorMsg = "Gagal submit: ${e.message}";
      }

      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal',
          text: errorMsg,
        );
      }
    } catch (e) {
      debugPrint("❌ Error submit: $e");
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal',
          text: "Gagal submit absen: $e",
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Content
        Scaffold(
          appBar: AppBar(
            title: const Text("Absensi"),
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Matkul
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.namaMatkul,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Pertemuan ke-${widget.pertemuan}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (widget.topic.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.topic,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Kamera Section
                const Text(
                  "Bukti Foto:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Camera Button or Preview
                if (imageBytes == null) ...[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isCameraReady ? _openCamera : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: isCameraReady ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isCameraReady
                                  ? "Tap untuk buka kamera"
                                  : "Memuat kamera...",
                              style: TextStyle(
                                fontSize: 16,
                                color: isCameraReady ? Colors.blue : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (!isCameraReady) ...[
                              const SizedBox(height: 12),
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openCamera,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Ambil Foto Ulang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],

                const Divider(height: 32),

                // Lokasi Section
                const Text(
                  "Lokasi:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: position != null
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: position != null
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        position == null
                            ? Icons.location_searching
                            : Icons.location_on,
                        color: position == null ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              position == null
                                  ? "Sedang mencari lokasi..."
                                  : "Lokasi berhasil diambil",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (position != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                "Lat: ${position!.latitude.toStringAsFixed(6)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "Lng: ${position!.longitude.toStringAsFixed(6)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                "Akurasi: ${position!.accuracy.toStringAsFixed(1)}m",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (position != null)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.blue),
                          onPressed: _getLocation,
                          tooltip: "Perbarui lokasi",
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (isSubmitting ||
                            imageBytes == null ||
                            position == null)
                        ? null
                        : _submitAbsen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSubmitting
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Mengirim...",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : const Text(
                            "KIRIM ABSENSI",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Pastikan foto dan lokasi sudah diambil sebelum submit",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Camera Overlay
        if (showingCamera)
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Column(
                children: [
                  // Info header
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Posisikan wajah Anda di tengah kamera",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Camera controls
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 40, top: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Cancel button
                        GestureDetector(
                          onTap: () {
                            debugPrint("🔴 Cancel button tapped!");
                            _cancelCamera();
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),

                        const SizedBox(width: 40),

                        // Capture button
                        GestureDetector(
                          onTap: () {
                            debugPrint("🔵 Capture button tapped!");
                            _capturePhoto();
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}