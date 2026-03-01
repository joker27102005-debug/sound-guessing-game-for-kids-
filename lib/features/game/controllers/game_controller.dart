import '../../../data/models/question_model.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../core/utils/random_generator.dart';
import '../../../core/database/local_db.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class GameController {
  late QuestionModel currentQuestion;
  List<QuestionModel> questions = [];

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  bool canTap = true;

  int score = 0;
  int streak = 0;
  int xp = 0;
  int lives = 3;

  int round = 1;
  int questionNumber = 0;
  int questionsPerRound = 5;

  int timeLeft = 15; // slower timer
  Timer? _timer;

  int _lastIndex = -1;

  bool get isRoundComplete => questionNumber % questionsPerRound == 0;

  bool get isGameOver => lives <= 0;

  String get level {
    if (xp < 20) return "Beginner";
    if (xp < 50) return "Pro";
    return "Master";
  }

  void loadQuestions() {
    questions = QuestionRepository.getQuestions();
    nextQuestion();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    timeLeft = 15;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (isGameOver) {
        t.cancel();
        return;
      }

      timeLeft--;

      if (timeLeft <= 0) {
        lives--;

        if (isGameOver) {
          t.cancel();
          return;
        }

        nextQuestion();
        startTimer();
      }
    });
  }

  void nextRound() {
    round++;
    questionNumber = 0;
    nextQuestion();
  }

  void nextQuestion() {
    if (isGameOver) return;

    int newIndex;

    do {
      newIndex = RandomGenerator.getRandomIndex(questions.length);
    } while (newIndex == _lastIndex && questions.length > 1);

    _lastIndex = newIndex;
    currentQuestion = questions[newIndex];

    questionNumber++;
    canTap = true;

    startTimer();
  }

  bool checkAnswer(String selected) {
    if (!canTap || isGameOver) return false;

    canTap = false;

    bool correct = selected == currentQuestion.correctAnswer;

    if (correct) {
      score++;
      streak++;
      xp += 5;
    } else {
      streak = 0;
      lives--;
    }

    playEffect(correct);

    return correct;
  }

  Future<void> saveGame() async {
    await LocalDB.insertGameRecord(
      score: score,
      xp: xp,
      round: round,
    );
  }

  Future<void> playSound() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource(currentQuestion.sound.replaceFirst("assets/", "")),
    );
  }

  Future<void> playEffect(bool correct) async {
    await _effectPlayer.stop();

    String path =
    correct ? "sounds/correct.mp3" : "sounds/wrong.mp3";

    await _effectPlayer.play(AssetSource(path));
  }
}