import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> top10 = [];
  List<Map<String, dynamic>> allSessions = [];
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    highScore = await DatabaseHelper.instance.getHighScore();
    top10 = await DatabaseHelper.instance.getTop10();
    allSessions = await DatabaseHelper.instance.getAllSessions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game History 📊"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🏆 HIGH SCORE CARD
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "🏆 HIGH SCORE",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          highScore.toString(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 TOP 10
              const Text(
                "Top 10 Leaderboard",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ...top10.asMap().entries.map((entry) {
                int rank = entry.key + 1;
                var session = entry.value;

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(rank.toString()),
                  ),
                  title: Text("Score: ${session['score']}"),
                  subtitle: Text(
                      "XP: ${session['xp']} | Level: ${session['level']}"),
                );
              }),

              const SizedBox(height: 20),

              /// 📅 FULL HISTORY
              const Text(
                "Full Game History",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ...allSessions.map((session) {
                DateTime date =
                DateTime.parse(session['date']);

                return Card(
                  child: ListTile(
                    title: Text("Score: ${session['score']}"),
                    subtitle: Text(
                        "XP: ${session['xp']} | Level: ${session['level']}\nDate: ${date.day}-${date.month}-${date.year}"),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}