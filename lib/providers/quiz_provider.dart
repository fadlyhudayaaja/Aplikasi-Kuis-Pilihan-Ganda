import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../data/quiz_data.dart';

/// InheritedWidget-based state management agar state kuis tidak hilang
/// saat rotasi layar atau navigasi antar halaman.
class QuizProvider extends InheritedWidget {
  final QuizState state;

  const QuizProvider({
    super.key,
    required this.state,
    required super.child,
  });

  static QuizState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<QuizProvider>();
    assert(provider != null, 'QuizProvider tidak ditemukan di widget tree');
    return provider!.state;
  }

  @override
  bool updateShouldNotify(QuizProvider oldWidget) => true;
}

/// Menyimpan seluruh state aplikasi kuis
class QuizState extends ChangeNotifier {
  // ── State global riwayat ────────────────────────────────────────────────────
  final List<QuizResult> _history = List.from(dummyHistory);
  List<QuizResult> get history => List.unmodifiable(_history);

  // ── State mata kuliah favorit ──────────────────────────────────────────────
  final Set<String> _favoriteSubjects = {};
  List<String> get favoriteSubjects => _favoriteSubjects.toList()
    ..sort((a, b) => subjects.indexOf(a).compareTo(subjects.indexOf(b)));

  bool isFavorite(String subject) => _favoriteSubjects.contains(subject);

  void toggleFavorite(String subject) {
    if (_favoriteSubjects.contains(subject)) {
      _favoriteSubjects.remove(subject);
    } else {
      _favoriteSubjects.add(subject);
    }
    notifyListeners();
  }

  // ── State sesi kuis aktif ───────────────────────────────────────────────────
  String _userName = '';
  String _nim = '';
  String _selectedSubject = '';
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  // Menyimpan index jawaban yang dipilih per soal (-1 = belum dijawab, -2 = timeout)
  List<int> _selectedAnswers = [];

  // ── Request tab switch dari MainScreen (untuk navigasi setelah kuis selesai)
  int _requestedTabIndex = -1;
  int get requestedTabIndex => _requestedTabIndex;

  void requestTab(int index) {
    _requestedTabIndex = index;
    notifyListeners();
  }

  void clearTabRequest() {
    _requestedTabIndex = -1;
  }

  // ── Theme mode (light / dark / system)
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  // Getters
  String get userName => _userName;
  String get nim => _nim;
  String get selectedSubject => _selectedSubject;
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  List<int> get selectedAnswers => List.unmodifiable(_selectedAnswers);

  int get totalQuestions => _questions.length;
  bool get isLastQuestion => _currentIndex >= _questions.length - 1;
  Question? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentIndex] : null;
  int get currentSelectedAnswer =>
      _selectedAnswers.isNotEmpty ? _selectedAnswers[_currentIndex] : -1;

  // ── Memulai sesi kuis baru ──────────────────────────────────────────────────
  void startQuiz({
    required String userName,
    required String nim,
    required String subject,
  }) {
    _userName = userName;
    _nim = nim;
    _selectedSubject = subject;
    _questions = questionBank[subject] ?? [];
    _currentIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _selectedAnswers = List.filled(_questions.length, -1);
    notifyListeners();
  }

  // ── Memilih jawaban untuk soal saat ini ─────────────────────────────────────
  void selectAnswer(int optionIndex) {
    if (_selectedAnswers[_currentIndex] != -1) return; // sudah dijawab
    _selectedAnswers[_currentIndex] = optionIndex;

    if (optionIndex == _questions[_currentIndex].correctIndex) {
      _correctAnswers++;
    } else {
      _wrongAnswers++;
    }
    notifyListeners();
  }

  // ── Timeout soal (waktu habis, soal dihitung salah) ─────────────────────────
  void timeoutQuestion() {
    if (_selectedAnswers[_currentIndex] != -1) return; // sudah dijawab
    _selectedAnswers[_currentIndex] = -2; // kode timeout
    _wrongAnswers++;
    notifyListeners();
  }

  // ── Pindah ke soal berikutnya ───────────────────────────────────────────────
  void nextQuestion() {
    if (!isLastQuestion) {
      _currentIndex++;
      notifyListeners();
    }
  }

  // ── Menyelesaikan kuis dan menghitung skor ──────────────────────────────────
  QuizResult finishQuiz() {
    _score = ((_correctAnswers / _questions.length) * 100).round();

    final result = QuizResult(
      userName: _userName,
      nim: _nim,
      subject: _selectedSubject,
      score: _score,
      totalQuestions: _questions.length,
      correctAnswers: _correctAnswers,
      wrongAnswers: _wrongAnswers,
      finishedAt: DateTime.now(),
    );

    _history.insert(0, result); // tambahkan di paling atas
    notifyListeners();
    return result;
  }

  // ── Reset state sesi (kembali ke home) ─────────────────────────────────────
  void resetQuiz() {
    _userName = '';
    _nim = '';
    _selectedSubject = '';
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _selectedAnswers = [];
    notifyListeners();
  }
}
