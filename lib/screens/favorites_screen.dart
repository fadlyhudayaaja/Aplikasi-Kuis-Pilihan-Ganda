import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'quiz_screen.dart';

/// Halaman Favorit – menampilkan daftar mata kuliah yang ditandai favorit.
/// Tap salah satu kartu untuk langsung memulai kuis mata kuliah tersebut.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final cw = Responsive.cw(context);
    final ch = Responsive.ch(context);
    // cb = referensi ukuran font/spasi yang aman di landscape maupun portrait
    final cb = Responsive.cwBase(context);
    final isLandscape = Responsive.isLandscape(context);

    return ListenableBuilder(
      listenable: QuizProvider.of(context),
      builder: (context, _) {
        final state = QuizProvider.of(context);
        final favorites = state.favoriteSubjects;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Responsive.constrain(
              context: context,
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  SizedBox(height: isLandscape ? 8 : ch * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: cw * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Mata Kuliah Favorit', style: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.w800,
                            // gunakan cb agar tidak meledak di landscape
                            fontSize: cb * 0.055,
                            color: theme.colorScheme.onSurface,
                          ), overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                color: Color(0xFFFFB300), size: 16),
                              const SizedBox(width: 4),
                              Text('${favorites.length} favorit', style: TextStyle(
                                fontFamily: 'Poppins', fontSize: cb * 0.033,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFB300),
                              )),
                            ],
                          ),
                        ),
                        if (!Responsive.isWide(context)) ...[
                          const SizedBox(width: 8),
                          const ThemeToggleButton(),
                        ],
                      ],
                    ),
                  ),

                  // ── Konten ───────────────────────────────────────────────
                  Expanded(
                    child: favorites.isEmpty
                        ? _EmptyState(primary: primary)
                        : SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: cw * 0.05,
                              vertical: isLandscape ? 8 : ch * 0.02,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Banner info — lebih kompak di landscape
                                if (!isLandscape)
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(cw * 0.04),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.star_rounded,
                                                    color: Colors.white, size: 20),
                                                  const SizedBox(width: 6),
                                                  Text('Favorit Kamu', style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: cb * 0.042,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Poppins',
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Tap salah satu mata kuliah\nuntuk langsung mulai kuis.',
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.85),
                                                  fontSize: cb * 0.030,
                                                  fontFamily: 'Poppins',
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.favorite_rounded,
                                          color: Colors.white.withValues(alpha: 0.4),
                                          size: cb * 0.14),
                                      ],
                                    ),
                                  ),
                                if (!isLandscape) const SizedBox(height: 16),
                                // Daftar kartu favorit
                                ...favorites.map((subject) => _FavoriteSubjectCard(
                                  subject: subject,
                                  onTap: () => _startQuiz(context, state, subject),
                                )),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _startQuiz(BuildContext context, QuizState state, String subject) {
    state.startQuiz(
      userName: state.userName.isNotEmpty ? state.userName : 'Pengguna',
      nim: state.nim.isNotEmpty ? state.nim : '000000',
      subject: subject,
    );
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, _) => FadeTransition(
          opacity: anim,
          child: const QuizScreen(),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}

// ── Kartu mata kuliah favorit ─────────────────────────────────────────────────
class _FavoriteSubjectCard extends StatelessWidget {
  final String subject;
  final VoidCallback onTap;

  const _FavoriteSubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cw = Responsive.cw(context);
    final cb = Responsive.cwBase(context);
    final accentColor = subjectColors[subject] ?? theme.colorScheme.primary;
    final iconData = subjectIcons[subject] ?? Icons.book_rounded;
    final desc = subjectDescriptions[subject] ?? '';
    final questionCount = questionBank[subject]?.length ?? 0;
    // Ukuran icon container lebih kecil di landscape
    final iconSize = cb * 0.13;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(
          horizontal: cw * 0.04,
          vertical: cb * 0.03,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(iconData, color: accentColor, size: iconSize * 0.5),
              ),
            ),
            SizedBox(width: cw * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(subject, style: TextStyle(
                          fontSize: cb * 0.038, fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: theme.colorScheme.onSurface,
                        ), overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded,
                        color: Color(0xFFFFB300), size: 16),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: cb * 0.030, fontFamily: 'Poppins',
                  ), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('$questionCount soal', style: TextStyle(
                      fontSize: cb * 0.026, fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins', color: accentColor,
                    )),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
              color: accentColor.withValues(alpha: 0.5), size: cb * 0.040),
          ],
        ),
      ),
    );
  }
}

// ── State kosong ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Color primary;
  const _EmptyState({required this.primary});

  @override
  Widget build(BuildContext context) {
    final cw = Responsive.cw(context);
    final cb = Responsive.cwBase(context);
    final ch = Responsive.ch(context);
    final state = QuizProvider.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: cw * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border_rounded,
              size: cb * 0.22, color: const Color(0xFFFFB300).withValues(alpha: 0.4)),
            SizedBox(height: ch * 0.02),
            Text('Belum ada favorit', style: TextStyle(
              fontFamily: 'Poppins', fontSize: cb * 0.048,
              fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface,
            )),
            SizedBox(height: ch * 0.008),
            Text('Tap ikon bintang di mata kuliah\nuntuk menambahkannya ke favorit',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: cb * 0.034,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
            SizedBox(height: ch * 0.03),
            CustomButton(
              label: 'Pilih Mata Kuliah',
              onPressed: () {
                state.requestTab(0);
              },
              icon: Icons.home_rounded,
              backgroundColor: primary,
            ),
          ],
        ),
      ),
    );
  }
}
