import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('game.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE game_sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      score INTEGER,
      xp INTEGER,
      level TEXT,
      date TEXT
    )
    ''');
  }

  Future<void> insertSession(int score, int xp, String level) async {
    final db = await instance.database;

    await db.insert('game_sessions', {
      'score': score,
      'xp': xp,
      'level': level,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getHighScore() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT MAX(score) as highScore FROM game_sessions');

    return result.first['highScore'] as int? ?? 0;
  }

  /// 🔥 NEW: Get Top 10 Scores
  Future<List<Map<String, dynamic>>> getTop10() async {
    final db = await instance.database;

    return await db.query(
      'game_sessions',
      orderBy: 'score DESC',
      limit: 10,
    );
  }

  /// 🔥 NEW: Get All Sessions (Latest First)
  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await instance.database;

    return await db.query(
      'game_sessions',
      orderBy: 'date DESC',
    );
  }
}