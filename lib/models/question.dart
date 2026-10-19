// Model untuk satu soal kuis
class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex; // index jawaban benar di list options

  const Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}
