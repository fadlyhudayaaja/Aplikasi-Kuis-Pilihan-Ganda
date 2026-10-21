// Model untuk menyimpan satu entri hasil/riwayat kuis
class QuizResult {
  final String userName;
  final String nim; // Nomor Induk Mahasiswa
  final String subject;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final DateTime finishedAt;

  const QuizResult({
    required this.userName,
    required this.nim,
    required this.subject,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.finishedAt,
  });

  // Menghitung persentase skor (0–100)
  double get percentage =>
      totalQuestions == 0 ? 0 : (correctAnswers / totalQuestions) * 100;
}
