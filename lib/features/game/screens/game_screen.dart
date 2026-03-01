import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../../../core/database/database_helper.dart';
import '../../history/screens/history_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameController controller = GameController();

  bool loaded = false;
  bool isProcessing = false;
  Color flashColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    controller.loadQuestions();
    loaded = true;

    /// UI refresh every second for timer
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() {});
      return true;
    });
  }

  /// 🔥 GAME OVER + SAVE SESSION
  Future<void> checkGameOver() async {
    if (controller.lives <= 0) {
      // Save session in SQLite
      await DatabaseHelper.instance.insertSession(
        controller.score,
        controller.xp,
        controller.level,
      );

      // Get High Score
      int highScore =
      await DatabaseHelper.instance.getHighScore();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Game Over"),
          content: Text(
            "Score: ${controller.score}\n"
                "XP: ${controller.xp}\n"
                "Level: ${controller.level}\n\n"
                "🏆 High Score: $highScore",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  controller.score = 0;
                  controller.xp = 0;
                  controller.streak = 0;
                  controller.lives = 3;
                  controller.round = 1;
                  controller.questionNumber = 0;
                  controller.loadQuestions();
                });
              },
              child: const Text("Restart"),
            )
          ],
        ),
      );
    }
  }

  void showRoundPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Round Complete 🎯"),
        content: Text(
            "Score: ${controller.score}\nXP: ${controller.xp}\nLevel: ${controller.level}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Next Round"),
          )
        ],
      ),
    );
  }

  Future<void> handleAnswer(String option) async {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    bool correct = controller.checkAnswer(option);

    setState(() {
      flashColor = correct
          ? Colors.green.withOpacity(0.3)
          : Colors.red.withOpacity(0.3);
    });

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      flashColor = Colors.transparent;

      if (controller.isRoundComplete) {
        showRoundPopup();
        controller.nextRound();
      } else {
        controller.nextQuestion();
      }

      isProcessing = false;
    });

    /// 🔥 CHECK GAME OVER AFTER EACH ANSWER
    await checkGameOver();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = controller.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess The Sound 🔊"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: flashColor,
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text("❤️ ${controller.lives}"),
                  Text("🔥 ${controller.streak}"),
                  Text("XP ${controller.xp}"),
                  Text("Round ${controller.round}"),
                  Text("⏱ ${controller.timeLeft}s"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => controller.playSound(),
              icon: const Icon(Icons.volume_up),
              label: const Text("Play Sound"),
            ),

            const SizedBox(height: 20),

            Text(
              question.questionText,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(20),
                crossAxisCount: 2,
                children: question.options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      key: ValueKey(
                        option +
                            controller.questionNumber
                                .toString(),
                      ),
                      onPressed: isProcessing
                          ? null
                          : () => handleAnswer(option),
                      child:
                      Text(option.toUpperCase()),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}