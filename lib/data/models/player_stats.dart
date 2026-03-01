class PlayerStats {
  final int? id;
  final int score;
  final int streak;
  final String level;
  final String date;

  PlayerStats({
    this.id,
    required this.score,
    required this.streak,
    required this.level,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score': score,
      'streak': streak,
      'level': level,
      'date': date,
    };
  }

  factory PlayerStats.fromMap(Map<String, dynamic> map) {
    return PlayerStats(
      id: map['id'],
      score: map['score'],
      streak: map['streak'],
      level: map['level'],
      date: map['date'],
    );
  }
}
