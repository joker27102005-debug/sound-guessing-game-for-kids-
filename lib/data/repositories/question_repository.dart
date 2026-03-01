import '../models/question_model.dart';

class QuestionRepository {
  static List<QuestionModel> getQuestions() {
    return [
      QuestionModel(
        id: "1",
        sound: "sounds/cow.mp3",
        correctAnswer: "cow",
        options: ["lion", "cow", "dog", "tiger"],
        category: "animal",
        questionText: "Which animal makes this sound?",
      ),

      QuestionModel(
        id: "2",
        sound: "sounds/dog.mp3",
        correctAnswer: "dog",
        options: ["cat", "dog", "cow", "lion"],
        category: "animal",
        questionText: "which animal makes this sound?",
      ),
    ];
  }
}
