import 'package:get/get.dart';
import 'package:hashmicro_test/database/db_helpers.dart';
import 'package:hashmicro_test/features/attendance/models/attendance_models.dart';

class HistoryController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  var historyList = <AttendanceModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final db = await _dbHelper.database;

      // Ambil session user saat ini
      final session = await _dbHelper.getUserSession();
      final isAdmin =
          session != null ? (session['isAdmin'] as bool? ?? false) : false;
      final userName =
          session != null ? (session['name'] as String? ?? 'User') : 'User';

      List<Map<String, dynamic>> maps;

      if (isAdmin) {
        // Jika Admin: Ambil semua riwayat absensi
        maps = await db.query('attendance_history', orderBy: 'id DESC');
      } else {
        // Jika User biasa: Ambil riwayat absensi diri sendiri saja
        maps = await db.query(
          'attendance_history',
          where: 'user_name = ?',
          whereArgs: [userName],
          orderBy: 'id DESC',
        );
      }

      historyList.value = List.generate(maps.length, (i) {
        return AttendanceModel(
          id: maps[i]['id'],
          date: maps[i]['date'],
          time: maps[i]['time'],
          latitude: maps[i]['latitude'],
          longitude: maps[i]['longitude'],
          locationName: maps[i]['location_name'],
          address: maps[i]['address'],
          status: maps[i]['status'],
          distance: MapsHelper.parseDouble(maps[i]['distance']),
          userName: maps[i]['user_name'] ?? 'User',
        );
      });
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}

class MapsHelper {
  static double parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return 0.0;
    }
  }
}
