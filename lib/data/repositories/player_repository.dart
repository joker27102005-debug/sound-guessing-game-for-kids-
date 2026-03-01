import '../../core/database/local_db.dart';
import '../models/player_stats.dart';

class PlayerRepository {
  Future<void> saveStats(PlayerStats stats) async {
    final db = await LocalDB.db;
    await db.insert('player_stats', stats.toMap());
  }

  Future<List<PlayerStats>> getAllStats() async {
    final db = await LocalDB.db;
    final result = await db.query(
      'player_stats',
      orderBy: 'id DESC',
    );

    return result.map((e) => PlayerStats.fromMap(e)).toList();
  }
}
