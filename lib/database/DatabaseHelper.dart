import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE passwords(
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        title TEXT,
        username TEXT,
        password TEXT,
        description TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.insert('users', user);
  }

  Future<int> insertPassword(Map<String, dynamic> password) async {
    Database db = await instance.database;
    return await db.insert('passwords', password);
  }

  Future<List<Map<String, dynamic>>> getPasswordsByUserId(int userId) async {
    Database db = await instance.database;
    return await db.query('passwords', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getPasswordsByUserName(String username) async {
    Database db = await instance.database;
    return await db.query('passwords', where: 'username = ?', whereArgs: [username]);
  }

  Future<bool> checkUsernameExists(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('users', where: 'username = ?', whereArgs: [username]);
    return result.isNotEmpty;
  }

  Future<int> checkLogin(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);

    if (result.isEmpty) {
      return -1;
    } else {
      return result[0]['id'];
    }
  }
}
