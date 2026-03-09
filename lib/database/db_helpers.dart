import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'attendance_system.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // Tabel Master Data Lokasi
        await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            latitude REAL,
            longitude REAL,
            address TEXT,
            created_at TEXT
          )
        ''');

        // Tabel Riwayat Absensi
        await db.execute('''
          CREATE TABLE attendance_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            time TEXT,
            latitude REAL,
            longitude REAL,
            location_name TEXT,
            address TEXT,
            status TEXT,
            distance REAL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE attendance_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT,
              time TEXT,
              latitude REAL,
              longitude REAL,
              location_name TEXT,
              address TEXT,
              status TEXT,
              distance REAL
            )
          ''');
        }
      },
    );
  }
}
