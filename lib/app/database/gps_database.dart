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
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itineraryId TEXT,
            latitude REAL,
            longitude REAL,
            timestamp TEXT,
            date TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE stops(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itineraryId TEXT,
            title TEXT,
            latitude REAL,
            longitude REAL,
            time TEXT,
            shift TEXT,
            direction TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Operações no banco de dados
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

  Future<void> insertStop(Map<String, dynamic> stop) async {
    final db = await database;
    await db.insert('stops', stop);
  }

  Future<void> updateStop(Map<String, dynamic> stop) async {
    final db = await database;
    await db.update('stops', stop, where: 'id = ?', whereArgs: [stop['id']]);
  }

  Future<void> deleteStop(int id) async {
    final db = await database;
    await db.delete('stops', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getStops(String itineraryId) async {
    final db = await database;
    return db
        .query('stops', where: 'itineraryId = ?', whereArgs: [itineraryId]);
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('locations');
    await db.delete('stops');
  }
}
