import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_button.dart';
import 'main_screen.dart';

/// Halaman Hasil – menampilkan skor akhir, NIM, statistik
class ResultScreen extends StatefulWidget {
  final QuizResult result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimCtrl;
  late AnimationController _cardAnimCtrl;
  late Animation<double> _scoreFade;
  late Animation<double> _scoreScale;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();

    _scoreAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scoreFade =
        CurvedAnimation(parent: _scoreAnimCtrl, curve: Curves.easeOut);
    _scoreScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scoreAnimCtrl, curve: Curves.elasticOut),
    );
    _cardFade =
        CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut));

    _scoreAnimCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _cardAnimCtrl.forward();
    });
  }

  @override
  void dispose() {
    _scoreAnimCtrl.dispose();
    _cardAnimCtrl.dispose();
    super.dispose();
  }

  Color _scoreColor(int score) {
    if (score >= 80) return const Color(0xFF43A047);
    if (score >= 60) return const Color(0xFFFB8C00);
    return const Color(0xFFE53935);
  }

  String _scoreLabel(int score) {
    if (score == 100) return '🏆 Sempurna!';
    if (score >= 80) return '🌟 Luar Biasa!';
    if (score >= 60) return '👍 Cukup Baik';
    return '💪 Tetap Semangat!';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final result = widget.result;
    final sColor = _scoreColor(result.score);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),

              // ── Header ─────────────────────────────────────────────────────
              Text(
                'Hasil Kuis',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.065,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: size.height * 0.004),
              Text(
                result.subject,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: size.width * 0.038,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: size.height * 0.04),

              // ── Lingkaran Skor ─────────────────────────────────────────────
              FadeTransition(
                opacity: _scoreFade,
                child: ScaleTransition(
                  scale: _scoreScale,
                  child: Container(
                    width: size.width * 0.45,
                    height: size.width * 0.45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: sColor.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(color: sColor, width: 4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${result.score}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.width * 0.13,
                            fontWeight: FontWeight.w900,
                            color: sColor,
                            height: 1,
                          ),
                        ),
                        Text(
                          'dari 100',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.width * 0.032,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.018),
              FadeTransition(
                opacity: _scoreFade,
                child: Text(
                  _scoreLabel(result.score),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.052,
                    fontWeight: FontWeight.w700,
                    color: sColor,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.035),

              // ── Kartu Detail Hasil ─────────────────────────────────────────
              SlideTransition(
                position: _cardSlide,
                child: FadeTransition(
                  opacity: _cardFade,
                  child: Column(
                    children: [
                      // Info pengguna (nama, NIM, mapel, waktu)
                      _InfoCard(
                        children: [
                          _InfoRow(
                            icon: Icons.person_rounded,
                            label: 'Nama',
                            value: result.userName,
                            color: primary,
                          ),
                          Divider(
                              height: size.height * 0.02,
                              color: Colors.grey.shade200),
                          _InfoRow(
                            icon: Icons.badge_rounded,
                            label: 'NIM',
                            value: result.nim,
                            color: primary,
                          ),
                          Divider(
                              height: size.height * 0.02,
                              color: Colors.grey.shade200),
                          _InfoRow(
                            icon: Icons.book_rounded,
                            label: 'Mata Kuliah',
                            value: result.subject,
                            color: primary,
                          ),
                          Divider(
                              height: size.height * 0.02,
                              color: Colors.grey.shade200),
                          _InfoRow(
                            icon: Icons.access_time_rounded,
                            label: 'Selesai pada',
                            value: _formatDateTime(result.finishedAt),
                            color: primary,
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.018),

                      // Statistik jawaban
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.quiz_rounded,
                              label: 'Total Soal',
                              value: '${result.totalQuestions}',
                              iconColor: primary,
                              bgColor: primary.withValues(alpha: 0.1),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.check_circle_rounded,
                              label: 'Benar',
                              value: '${result.correctAnswers}',
                              iconColor: const Color(0xFF43A047),
                              bgColor: const Color(0xFFE8F5E9),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.cancel_rounded,
                              label: 'Salah',
                              value: '${result.wrongAnswers}',
                              iconColor: const Color(0xFFE53935),
                              bgColor: const Color(0xFFFFEBEE),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.018),

                      // Progress bar akurasi
                      _InfoCard(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Akurasi Jawaban',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: size.width * 0.038,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '${result.percentage.round()}%',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: size.width * 0.038,
                                  fontWeight: FontWeight.w700,
                                  color: sColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.012),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                  begin: 0, end: result.percentage / 100),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeInOut,
                              builder: (ctx, val, _) {
                                return LinearProgressIndicator(
                                  value: val,
                                  minHeight: size.height * 0.014,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    sColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.035),

              // ── Tombol Aksi ────────────────────────────────────────────────
              SlideTransition(
                position: _cardSlide,
                child: FadeTransition(
                  opacity: _cardFade,
                  child: Column(
                    children: [
                      CustomButton(
                        label: 'Lihat Riwayat',
                        onPressed: () {
                          final state = QuizProvider.of(context);
                          state.resetQuiz();
                          state.requestTab(1); // Switch ke tab Histori
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainScreen(),
                            ),
                            (_) => false,
                          );
                        },
                        icon: Icons.history_rounded,
                        backgroundColor: primary,
                      ),
                      SizedBox(height: size.height * 0.014),
                      CustomButton(
                        label: 'Kembali ke Beranda',
                        onPressed: () {
                          final state = QuizProvider.of(context);
                          state.resetQuiz();
                          state.requestTab(0); // Switch ke tab Beranda
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainScreen(),
                            ),
                            (_) => false,
                          );
                        },
                        icon: Icons.home_rounded,
                        isOutlined: true,
                        backgroundColor: primary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month]} ${dt.year}, $hour:$minute';
  }
}

// ── Kartu pembungkus info ──────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// ── Satu baris info ────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Icon(icon, color: color, size: size.width * 0.05),
        SizedBox(width: size.width * 0.03),
        Text(
          '$label:',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size.width * 0.036,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(width: size.width * 0.02),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.036,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Kartu statistik kecil ─────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color bgColor;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.018,
        horizontal: size.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: size.width * 0.055),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.055,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.028,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
