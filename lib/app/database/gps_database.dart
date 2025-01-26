import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GPSDatabase {
  static final GPSDatabase _instance = GPSDatabase._internal();
  static Database? _database;

  GPSDatabase._internal();

  factory GPSDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'gps_locations.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            latitude REAL,
            longitude REAL,
            timestamp TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertLocation(Map<String, dynamic> location) async {
    final db = await database;
    await db.insert('locations', location);
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await database;
    return db.query('locations');
  }

  Future<void> clearLocations() async {
    final db = await database;
    await db.delete('locations');
  }
}
