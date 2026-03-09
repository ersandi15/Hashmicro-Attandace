import 'package:hashmicro_test/database/db_helpers.dart';
import 'package:hashmicro_test/features/location_master/models/location_models.dart';

class LocationRepository {
  final DBHelper _dbHelper = DBHelper();

  // Simpan Master Data Lokasi
  Future<int> insertLocation(LocationModel location) async {
    final db = await _dbHelper.database;
    return await db.insert('locations', location.toMap());
  }

  // Ambil Semua Lokasi untuk Dropdown Absensi
  Future<List<LocationModel>> getAllLocations() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('locations');
    return List.generate(maps.length, (i) => LocationModel.fromMap(maps[i]));
  }
}
