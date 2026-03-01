class QuestionModel {
  final String id;
  final String sound;
  final String correctAnswer;
  final List<String> options;
  final String category;
  final String questionText;
  final Map<String, String>? optionImages;

  QuestionModel({
    required this.id,
    required this.sound,
    required this.correctAnswer,
    required this.options,
    required this.category,
    required this.questionText,
    this.optionImages,
  });
}
