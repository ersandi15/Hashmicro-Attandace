import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:hashmicro_test/features/attendance/repositories/attendance_repositories.dart';
import 'package:hashmicro_test/features/location_master/models/location_models.dart';
import 'package:hashmicro_test/features/attendance/models/attendance_models.dart';
import 'package:hashmicro_test/services/location_service.dart';
import 'package:hashmicro_test/utils/location_helpers.dart';
import 'package:hashmicro_test/database/db_helpers.dart';
import 'package:hashmicro_test/utils/ui_helpers.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class AttendanceController extends GetxController {
  final AttendanceRepository _repo = AttendanceRepository();
  final LocationService _locationService = LocationService();

  var masterLocations = <LocationModel>[].obs;
  var selectedLocation = Rxn<LocationModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations(); // Muat daftar kantor saat halaman dibuka
  }

  void fetchLocations() async {
    masterLocations.value = await _repo.getMasterLocations();
  }

  Future<void> submitAttendance() async {
    if (selectedLocation.value == null) {
      UIHelper.showErrorDialog(
        title: "Error",
        message: "Pilih lokasi kantor terlebih dahulu",
      );
      return;
    }

    try {
      isLoading.value = true;

      // 1. Ambil posisi user sekarang
      final userPos = await _locationService.getCurrentLocation();

      // Reverse geocoding untuk mendapatkan alamat user
      String userAddress = "Alamat tidak ditemukan";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          userPos.latitude,
          userPos.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          userAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}";
        }
      } catch (e) {
        // Abaikan jika reverse geocoding gagal
      }

      // 2. Hitung jarak ke lokasi kantor terpilih
      double distance = LocationHelper.calculateDistance(
        userPos.latitude,
        userPos.longitude,
        selectedLocation.value?.latitude ?? 0,
        selectedLocation.value?.longitude ?? 0,
      );

      // 3. Verifikasi radius 50 meter
      bool isSuccess = LocationHelper.isWithinRadius(distance);
      String status = isSuccess ? "Success" : "Rejected";

      // --- BAGIAN YANG DITAMBAHKAN (TIMEZONE LOGIC) ---
      // Ambil ID Timezone dari perangkat (Contoh: "Asia/Jakarta")
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      final String currentTimeZone = timezoneInfo.identifier;
      final location = tz.getLocation(currentTimeZone);

      // Gunakan TZDateTime agar waktu terkunci pada zona yang benar
      final now = tz.TZDateTime.now(location);
      // ------------------------------------------------

      // 4. Record ke SQLite
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final formattedTime = DateFormat('HH:mm:ss').format(now);

      // Ambil nama user dari session
      final session = await DBHelper().getUserSession();
      final userName =
          session != null ? (session['name'] as String? ?? 'User') : 'User';

      // Pastikan model kamu sudah menerima parameter 'timezone'
      final attendanceRecord = AttendanceModel(
        date: formattedDate,
        time: formattedTime,
        latitude: userPos.latitude,
        longitude: userPos.longitude,
        locationName: selectedLocation.value?.name ?? "Unknown Location",
        address: userAddress,
        status: status,
        distance: distance,
        userName: userName,
        timezone: currentTimeZone, // <-- Simpan zona waktu ke SQLite
      );

      await _repo.saveAttendance(attendanceRecord);

      // 5. Tampilkan Dialog
      if (isSuccess) {
        UIHelper.showSuccessDialog(
          title: "Absensi Berhasil",
          message:
              "Anda berada di radius aman (${distance.toStringAsFixed(1)}m).\nZona Waktu: $currentTimeZone\nData telah dicatat.",
          onConfirm: () {
            // Tutup dialog dan halaman presensi (Get back 2 kali), kembali ke Dashboard.
            Get.close(2);
          },
        );
      } else {
        UIHelper.showErrorDialog(
          title: "Absensi Ditolak",
          message:
              "Jarak Anda saat ini ${distance.toStringAsFixed(1)}m. Maksimal radius adalah 50 meter.\nData penolakan tetap dicatat untuk audit.",
        );
      }
    } catch (e) {
      UIHelper.showErrorDialog(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
