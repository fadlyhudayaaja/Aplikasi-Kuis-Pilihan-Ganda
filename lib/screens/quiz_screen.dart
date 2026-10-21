import 'dart:async';
import 'package:flutter/material.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_indicator_bar.dart';
import 'result_screen.dart';

/// Durasi timer per soal (detik)
const int kQuestionTimerSeconds = 30;

/// Halaman Kuis – menampilkan soal pilihan ganda satu per satu dengan timer
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _questionAnimCtrl;
  late Animation<double> _questionFade;
  late Animation<Offset> _questionSlide;

  // ── Timer state ────────────────────────────────────────────────────────────
  Timer? _timer;
  int _secondsLeft = kQuestionTimerSeconds;

  @override
  void initState() {
    super.initState();
    _questionAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _questionFade =
        CurvedAnimation(parent: _questionAnimCtrl, curve: Curves.easeOut);
    _questionSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _questionAnimCtrl, curve: Curves.easeOut));
    _questionAnimCtrl.forward();
    _startTimer();
  }

  @override
  void dispose() {
    _questionAnimCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // ── Timer: mulai hitung mundur ─────────────────────────────────────────────
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = kQuestionTimerSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          t.cancel();
          _onTimeOut();
        }
      });
    });
  }

  // ── Waktu habis: hitung sebagai salah & tampilkan jawaban benar ────────────
  void _onTimeOut() {
    final state = QuizProvider.of(context);
    if (state.currentSelectedAnswer == -1) {
      state.timeoutQuestion();
      // Auto lanjut setelah 2 detik
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _onNextOrFinish(state);
      });
    }
  }

  void _resetTimerForNextQuestion() {
    _timer?.cancel();
    _startTimer();
  }

  void _animateToNext() {
    _questionAnimCtrl.reverse().then((_) {
      _questionAnimCtrl.forward();
    });
  }

  void _onNextOrFinish(QuizState state) {
    if (state.isLastQuestion) {
      _timer?.cancel();
      final result = state.finishQuiz();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, _) => FadeTransition(
            opacity: anim,
            child: ResultScreen(result: result),
          ),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      _animateToNext();
      Future.delayed(const Duration(milliseconds: 180), () {
        state.nextQuestion();
        _resetTimerForNextQuestion();
      });
    }
  }

  void _confirmExit(BuildContext context) {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari Kuis?',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Progres kuis kamu akan hilang jika keluar sekarang.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer(); // lanjut timer
            },
            child: const Text(
              'Lanjutkan',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              QuizProvider.of(context).resetQuiz();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Keluar',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Warna timer berdasarkan sisa waktu ──────────────────────────────────────
  Color _timerColor() {
    if (_secondsLeft > 15) return const Color(0xFF43A047);
    if (_secondsLeft > 8) return const Color(0xFFFB8C00);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ListenableBuilder(
      listenable: QuizProvider.of(context),
      builder: (context, _) {
        final state = QuizProvider.of(context);
        final question = state.currentQuestion;

        if (question == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final answered = state.currentSelectedAnswer != -1;
        final timedOut = state.currentSelectedAnswer == -2;
        final labels = ['A', 'B', 'C', 'D'];

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmExit(context);
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F3FF),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_rounded, color: primary),
                onPressed: () => _confirmExit(context),
              ),
              title: Text(
                state.selectedSubject,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: size.width * 0.042,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.04),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${state.currentIndex + 1}/${state.totalQuestions}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.036,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.055,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.01),

                        // ── Progress Bar ─────────────────────────────────────
                        QuizProgressBar(
                          current: state.currentIndex,
                          total: state.totalQuestions,
                        ),

                        SizedBox(height: size.height * 0.018),

                        // ── Timer Widget ─────────────────────────────────────
                        _TimerWidget(
                          secondsLeft: _secondsLeft,
                          total: kQuestionTimerSeconds,
                          timerColor: _timerColor(),
                          answered: answered,
                          timedOut: timedOut,
                        ),

                        SizedBox(height: size.height * 0.018),

                        // ── Kartu Soal & Jawaban ─────────────────────────────
                        Expanded(
                          child: SlideTransition(
                            position: _questionSlide,
                            child: FadeTransition(
                              opacity: _questionFade,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Badge soal
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Soal ${state.currentIndex + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        if (timedOut) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE53935),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.timer_off_rounded,
                                                    color: Colors.white,
                                                    size: 14),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Waktu Habis!',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.016),

                                    // Teks soal
                                    Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.all(size.width * 0.05),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withValues(alpha: 0.06),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        question.questionText,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: size.width * 0.042,
                                          fontWeight: FontWeight.w600,
                                          height: 1.55,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: size.height * 0.018),

                                    // ── Opsi Jawaban ──────────────────────────
                                    ...List.generate(
                                      question.options.length,
                                      (i) {
                                        AnswerState ansState;
                                        final sel = state.currentSelectedAnswer;
                                        if (sel == -1) {
                                          ansState = AnswerState.normal;
                                        } else if (i == question.correctIndex) {
                                          ansState = AnswerState.correct;
                                        } else if (i == sel && sel != -2) {
                                          ansState = AnswerState.wrong;
                                        } else {
                                          ansState = AnswerState.normal;
                                        }

                                        return AnswerOptionCard(
                                          label: labels[i],
                                          optionText: question.options[i],
                                          state: ansState,
                                          onTap: answered
                                              ? null
                                              : () {
                                                  _timer?.cancel();
                                                  state.selectAnswer(i);
                                                },
                                        );
                                      },
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── Tombol Selanjutnya / Selesai ─────────────────────
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                            bottom: size.height * 0.025,
                          ),
                          child: Center(
                            child: CustomButton(
                              label: state.isLastQuestion
                                  ? 'Selesaikan Kuis'
                                  : 'Soal Berikutnya',
                              onPressed: answered
                                  ? () => _onNextOrFinish(state)
                                  : null,
                              icon: state.isLastQuestion
                                  ? Icons.flag_rounded
                                  : Icons.arrow_forward_rounded,
                              backgroundColor: primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Widget Timer Countdown ──────────────────────────────────────────────────────
class _TimerWidget extends StatelessWidget {
  final int secondsLeft;
  final int total;
  final Color timerColor;
  final bool answered;
  final bool timedOut;

  const _TimerWidget({
    required this.secondsLeft,
    required this.total,
    required this.timerColor,
    required this.answered,
    required this.timedOut,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final progress = answered ? 0.0 : secondsLeft / total;
    final displaySeconds = answered && !timedOut ? total : secondsLeft;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.045,
        vertical: size.height * 0.014,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon timer
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: timerColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              timedOut
                  ? Icons.timer_off_rounded
                  : Icons.timer_outlined,
              color: timerColor,
              size: size.width * 0.055,
            ),
          ),
          SizedBox(width: size.width * 0.03),

          // Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timedOut
                      ? 'Waktu Habis!'
                      : answered
                          ? 'Soal Terjawab'
                          : 'Sisa Waktu',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.03,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: progress, end: progress),
                    duration: const Duration(milliseconds: 300),
                    builder: (_, val, _) => LinearProgressIndicator(
                      value: val,
                      minHeight: size.height * 0.008,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(timerColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.03),

          // Angka countdown
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size.width * 0.14,
            height: size.width * 0.14,
            decoration: BoxDecoration(
              color: timerColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: timerColor.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$displaySeconds',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.048,
                  fontWeight: FontWeight.w800,
                  color: timerColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
