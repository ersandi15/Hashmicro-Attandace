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
      version: 4,
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
            distance REAL,
            user_name TEXT
          )
        ''');

        // Tabel User Session
        await db.execute('''
          CREATE TABLE user_session (
            id INTEGER PRIMARY KEY DEFAULT 1,
            is_admin INTEGER NOT NULL,
            name TEXT
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
              distance REAL,
              user_name TEXT
            )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE user_session (
              id INTEGER PRIMARY KEY DEFAULT 1,
              is_admin INTEGER NOT NULL
            )
          ''');
        }
        if (oldVersion < 4) {
          try {
            await db.execute('ALTER TABLE user_session ADD COLUMN name TEXT');
          } catch (e) {
            // Column might already exist
          }
        }
        if (oldVersion < 5) {
          try {
            await db.execute(
              'ALTER TABLE attendance_history ADD COLUMN user_name TEXT',
            );
          } catch (e) {
            // Abaikan jika sudah ada
          }
        }
      },
    );
  }

  // --- CRUD User Session ---
  Future<void> saveUserSession(bool isAdmin, String name) async {
    final db = await database;
    await db.insert('user_session', {
      'id': 1,
      'is_admin': isAdmin ? 1 : 0,
      'name': name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserSession() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_session',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return {
        'isAdmin': (maps.first['is_admin'] as int) == 1,
        'name': maps.first['name'] as String? ?? 'User',
      };
    }
    return null; // Default null
  }

  Future<void> clearUserSession() async {
    final db = await database;
    await db.delete('user_session');
  }
}
