import 'package:flutter/material.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_indicator_bar.dart';
import 'result_screen.dart';

/// Halaman Kuis – menampilkan soal pilihan ganda satu per satu
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
    ).animate(CurvedAnimation(parent: _questionAnimCtrl, curve: Curves.easeOut));
    _questionAnimCtrl.forward();
  }

  @override
  void dispose() {
    _questionAnimCtrl.dispose();
    super.dispose();
  }

  void _animateToNext() {
    _questionAnimCtrl.reverse().then((_) {
      _questionAnimCtrl.forward();
    });
  }

  void _onNextOrFinish(QuizState state) {
    if (state.isLastQuestion) {
      // Selesaikan kuis dan ambil hasilnya
      final result = state.finishQuiz();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => FadeTransition(
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
      });
    }
  }

  void _confirmExit(BuildContext context) {
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
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Lanjutkan',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              QuizProvider.of(context).resetQuiz();
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke home
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
        final labels = ['A', 'B', 'C', 'D'];

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
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
                // Indikator nomor soal
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.04),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
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
                        SizedBox(height: size.height * 0.015),

                        // ── Progress Bar ─────────────────────────────────────
                        QuizProgressBar(
                          current: state.currentIndex,
                          total: state.totalQuestions,
                        ),

                        SizedBox(height: size.height * 0.025),

                        // ── Kartu Soal ───────────────────────────────────────
                        Expanded(
                          child: SlideTransition(
                            position: _questionSlide,
                            child: FadeTransition(
                              opacity: _questionFade,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Badge nomor soal
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
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.016),

                                    // Teks soal
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(size.width * 0.05),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.06),
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

                                    SizedBox(height: size.height * 0.022),

                                    // ── Opsi Jawaban ─────────────────────────
                                    ...List.generate(
                                      question.options.length,
                                      (i) {
                                        AnswerState ansState;
                                        if (state.currentSelectedAnswer == -1) {
                                          ansState = AnswerState.normal;
                                        } else if (i ==
                                            question.correctIndex) {
                                          ansState = AnswerState.correct;
                                        } else if (i ==
                                            state.currentSelectedAnswer) {
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
                                              : () =>
                                                  state.selectAnswer(i),
                                        );
                                      },
                                    ),
                                    SizedBox(height: size.height * 0.025),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── Tombol Selanjutnya / Selesai ─────────────────────
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.012,
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
