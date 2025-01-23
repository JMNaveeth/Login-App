import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DatabaseService {
  static Database? _db;

    static Future<void> initializeDatabase() async {
    // Initialize FFI for Windows
    sqfliteFfiInit();
    // Set databaseFactory to use FFI
    databaseFactory = databaseFactoryFfi;
  }

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    
    // Initialize database first
    await initializeDatabase();
    
    _db = await openDatabase(
      join(await getDatabasesPath(), 'user_data.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE users(User_Code TEXT, User_Display_Name TEXT, Email TEXT, User_Employee_Code TEXT, Company_Code TEXT)"
        );
        await db.execute(
          "CREATE TABLE credentials(username TEXT PRIMARY KEY, password TEXT)"
        );
      },
      version: 1,
    );
    return _db!;
  }

  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final db = await getDatabase();
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> saveCredentials(String username, String password) async {
    final db = await getDatabase();
    await db.insert(
      'credentials',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, String>?> getStoredCredentials() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('credentials');
    if (maps.isNotEmpty) {
      return {
        'username': maps[0]['username'],
        'password': maps[0]['password'],
      };
    }
    return null;
  }
}
