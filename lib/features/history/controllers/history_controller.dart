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

      // Mengambil data dari terbaru ke terlama
      final List<Map<String, dynamic>> maps = await db.query(
        'attendance_history',
        orderBy: 'id DESC',
      );

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
