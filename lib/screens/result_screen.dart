import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
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
    _scoreAnimCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _cardAnimCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scoreFade = CurvedAnimation(parent: _scoreAnimCtrl, curve: Curves.easeOut);
    _scoreScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scoreAnimCtrl, curve: Curves.elasticOut));
    _cardFade = CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardAnimCtrl, curve: Curves.easeOut));
    _scoreAnimCtrl.forward();
    Future.delayed(const Duration(milliseconds: 400), () => _cardAnimCtrl.forward());
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
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final cw = Responsive.cw(context);
    final ch = Responsive.ch(context);
    final isLandscape = Responsive.isLandscape(context);
    final cb = Responsive.cwBase(context); // font/spacing base
    final result = widget.result;
    final sColor = _scoreColor(result.score);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Responsive.constrain(
          context: context,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: cw * 0.06),
            child: isLandscape
                ? _buildLandscape(cw, ch, cb, theme, primary, result, sColor)
                : _buildPortrait(cw, ch, cb, theme, primary, result, sColor),
          ),
        ),
      ),
    );
  }

  // ── Portrait layout ──────────────────────────────────────────────────────────
  Widget _buildPortrait(double cw, double ch, double cb, ThemeData theme,
      Color primary, QuizResult result, Color sColor) {
    return Column(
      children: [
        SizedBox(height: ch * 0.04),
        _buildHeader(cb, ch, theme, result),
        SizedBox(height: ch * 0.04),
        _buildScoreCircle(cb, theme, result, sColor),
        SizedBox(height: ch * 0.018),
        _buildScoreLabel(cb, result, sColor),
        SizedBox(height: ch * 0.035),
        _buildDetailCards(cb, ch, theme, primary, result, sColor),
        SizedBox(height: ch * 0.035),
        _buildActionButtons(cb, ch, primary),
        SizedBox(height: ch * 0.04),
      ],
    );
  }

  // ── Landscape layout (2 kolom: skor kiri, detail kanan) ──────────────────────
  Widget _buildLandscape(double cw, double ch, double cb, ThemeData theme,
      Color primary, QuizResult result, Color sColor) {
    return Column(
      children: [
        const SizedBox(height: 12),
        _buildHeader(cb, ch, theme, result),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom kiri: skor + label + tombol
            Expanded(
              child: Column(
                children: [
                  _buildScoreCircle(cb, theme, result, sColor),
                  const SizedBox(height: 8),
                  _buildScoreLabel(cb, result, sColor),
                  const SizedBox(height: 12),
                  _buildActionButtons(cb, ch, primary),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Kolom kanan: detail
            Expanded(child: _buildDetailCards(cb, ch, theme, primary, result, sColor)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Components ──────────────────────────────────────────────────────────────
  Widget _buildHeader(double cb, double ch, ThemeData theme, QuizResult result) {
    return Column(
      children: [
        Text('Hasil Kuis', style: TextStyle(
          fontFamily: 'Poppins', fontSize: cb * 0.065, fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface,
        )),
        SizedBox(height: ch * 0.004),
        Text(result.subject, style: TextStyle(
          fontFamily: 'Poppins', fontSize: cb * 0.038,
          color: theme.colorScheme.onSurfaceVariant,
        )),
      ],
    );
  }

  Widget _buildScoreCircle(double cb, ThemeData theme, QuizResult result, Color sColor) {
    return FadeTransition(
      opacity: _scoreFade,
      child: ScaleTransition(
        scale: _scoreScale,
        child: Container(
          width: cb * 0.45, height: cb * 0.45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: sColor.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5)],
            border: Border.all(color: sColor, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${result.score}', style: TextStyle(
                fontFamily: 'Poppins', fontSize: cb * 0.13, fontWeight: FontWeight.w900,
                color: sColor, height: 1,
              )),
              Text('dari 100', style: TextStyle(
                fontFamily: 'Poppins', fontSize: cb * 0.032,
                color: theme.colorScheme.onSurfaceVariant,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreLabel(double cb, QuizResult result, Color sColor) {
    return FadeTransition(
      opacity: _scoreFade,
      child: Text(_scoreLabel(result.score), style: TextStyle(
        fontFamily: 'Poppins', fontSize: cb * 0.052,
        fontWeight: FontWeight.w700, color: sColor,
      )),
    );
  }

  Widget _buildDetailCards(double cb, double ch, ThemeData theme,
      Color primary, QuizResult result, Color sColor) {
    return SlideTransition(
      position: _cardSlide,
      child: FadeTransition(
        opacity: _cardFade,
        child: Column(
          children: [
            _InfoCard(
              cb: cb,
              children: [
                _InfoRow(icon: Icons.person_rounded, label: 'Nama', value: result.userName, color: primary, cb: cb),
                Divider(height: ch * 0.02, color: theme.colorScheme.outline.withValues(alpha: 0.15)),
                _InfoRow(icon: Icons.badge_rounded, label: 'NIM', value: result.nim, color: primary, cb: cb),
                Divider(height: ch * 0.02, color: theme.colorScheme.outline.withValues(alpha: 0.15)),
                _InfoRow(icon: Icons.book_rounded, label: 'Mata Kuliah', value: result.subject, color: primary, cb: cb),
                Divider(height: ch * 0.02, color: theme.colorScheme.outline.withValues(alpha: 0.15)),
                _InfoRow(icon: Icons.access_time_rounded, label: 'Selesai pada',
                    value: _formatDateTime(result.finishedAt), color: primary, cb: cb),
              ],
            ),
            SizedBox(height: ch * 0.014),
            Row(
              children: [
                Expanded(child: _StatCard(icon: Icons.quiz_rounded, label: 'Total Soal',
                  value: '${result.totalQuestions}', iconColor: primary,
                  bgColor: primary.withValues(alpha: 0.1), cb: cb)),
                const SizedBox(width: 8),
                Expanded(child: _StatCard(icon: Icons.check_circle_rounded, label: 'Benar',
                  value: '${result.correctAnswers}', iconColor: const Color(0xFF43A047),
                  bgColor: const Color(0xFF43A047).withValues(alpha: 0.1), cb: cb)),
                const SizedBox(width: 8),
                Expanded(child: _StatCard(icon: Icons.cancel_rounded, label: 'Salah',
                  value: '${result.wrongAnswers}', iconColor: const Color(0xFFE53935),
                  bgColor: const Color(0xFFE53935).withValues(alpha: 0.1), cb: cb)),
              ],
            ),
            SizedBox(height: ch * 0.014),
            _InfoCard(
              cb: cb,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Akurasi Jawaban', style: TextStyle(fontFamily: 'Poppins',
                      fontSize: cb * 0.036, fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
                    Text('${result.percentage.round()}%', style: TextStyle(fontFamily: 'Poppins',
                      fontSize: cb * 0.036, fontWeight: FontWeight.w700, color: sColor)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: result.percentage / 100),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeInOut,
                    builder: (ctx, val, _) => LinearProgressIndicator(
                      value: val, minHeight: 10,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(sColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(double cb, double ch, Color primary) {
    return SlideTransition(
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
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 2)),
                  (_) => false);
              },
              icon: Icons.history_rounded, backgroundColor: primary,
            ),
            SizedBox(height: ch * 0.012),
            CustomButton(
              label: 'Kembali ke Beranda',
              onPressed: () {
                final state = QuizProvider.of(context);
                state.resetQuiz();
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 0)),
                  (_) => false);
              },
              icon: Icons.home_rounded, isOutlined: true, backgroundColor: primary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month]} ${dt.year}, $hour:$minute';
  }
}

// ── Kartu pembungkus info ──────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  final double cb;
  const _InfoCard({required this.children, required this.cb});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cb * 0.045),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.06),
          blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

// ── Satu baris info ────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  final double cb;
  const _InfoRow({required this.icon, required this.label, required this.value,
    required this.color, required this.cb});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: cb * 0.048),
        SizedBox(width: cb * 0.025),
        Text('$label:', style: TextStyle(fontFamily: 'Poppins',
          fontSize: cb * 0.034, color: theme.colorScheme.onSurfaceVariant)),
        SizedBox(width: cb * 0.015),
        Expanded(child: Text(value, textAlign: TextAlign.end, style: TextStyle(
          fontFamily: 'Poppins', fontSize: cb * 0.034, fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface))),
      ],
    );
  }
}

// ── Kartu statistik kecil ─────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color iconColor, bgColor;
  final double cb;
  const _StatCard({required this.icon, required this.label, required this.value,
    required this.iconColor, required this.bgColor, required this.cb});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: cb * 0.04, horizontal: cb * 0.02),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.05),
          blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: cb * 0.05),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: cb * 0.052,
            fontWeight: FontWeight.w800, color: iconColor)),
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: cb * 0.026,
            color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
