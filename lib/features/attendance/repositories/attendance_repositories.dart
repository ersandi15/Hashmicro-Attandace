import 'package:hashmicro_test/database/db_helpers.dart';
import 'package:hashmicro_test/features/attendance/models/attendance_models.dart';
import 'package:hashmicro_test/features/location_master/models/location_models.dart';

class AttendanceRepository {
  final DBHelper _dbHelper = DBHelper();

  // Ambil semua lokasi kantor untuk dipilih user
  Future<List<LocationModel>> getMasterLocations() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('locations');
    return List.generate(maps.length, (i) => LocationModel.fromMap(maps[i]));
  }

  // Simpan riwayat absen
  Future<int> saveAttendance(AttendanceModel attendance) async {
    final db = await _dbHelper.database;
    return await db.insert('attendance_history', attendance.toMap());
  }
}
