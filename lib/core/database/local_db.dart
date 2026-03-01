import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'game.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE game_records(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            score INTEGER,
            xp INTEGER,
            round INTEGER,
            playedAt TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertGameRecord({
    required int score,
    required int xp,
    required int round,
  }) async {
    final db = await database;

    await db.insert(
      'game_records',
      {
        'score': score,
        'xp': xp,
        'round': round,
        'playedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query('game_records', orderBy: 'id DESC');
  }

  static Future<int> getHighestScore() async {
    final db = await database;

    final result =
    await db.rawQuery('SELECT MAX(score) as maxScore FROM game_records');

    return result.first['maxScore'] as int? ?? 0;
  }
}