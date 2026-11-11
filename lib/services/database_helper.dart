import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'rick_morty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, password TEXT)',
        );
      },
    );
  }

  // Fungsi untuk Register
  Future<int> registerUser(String name, String password) async {
    final db = await database;
    return await db.insert('users', {'name': name, 'password': password});
  }

  // Fungsi untuk Login (Cek apakah nama & password cocok)
  Future<bool> loginUser(String name, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'name = ? AND password = ?',
      whereArgs: [name, password],
    );
    return res.isNotEmpty;
  }
}
