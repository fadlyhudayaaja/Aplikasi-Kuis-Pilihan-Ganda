import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import '../data/quiz_data.dart';
import '../providers/quiz_provider.dart';

/// Halaman Riwayat – tabel riwayat kuis dengan NIM dan statistik ringkasan
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Color _scoreColor(int score) {
    if (score >= 80) return const Color(0xFF43A047);
    if (score >= 60) return const Color(0xFFFB8C00);
    return const Color(0xFFE53935);
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
    return '${dt.day} ${months[dt.month]} ${dt.year}\n$hour:$minute WIB';
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
        final history = state.history;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F3FF),
          body: SafeArea(
            child: history.isEmpty
                ? Column(
                    children: [
                      // ── Header (tanpa back button, karena tab) ──────────────
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Riwayat Kuis',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                fontSize: size.width * 0.065,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '0 kuis',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: size.width * 0.033,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _EmptyState(primary: primary)),
                    ],
                  )
                : Column(
                  children: [
                    // ── Header (tanpa back button, karena tab) ──────────────
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Riwayat Kuis',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: size.width * 0.065,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${history.length} kuis',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: size.width * 0.033,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ── Ringkasan statistik ─────────────────────────────────
                    _SummaryHeader(history: history, primary: primary),

                    // ── Judul ───────────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.height * 0.012,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detail Riwayat',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: size.width * 0.042,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),

                    // ── Daftar riwayat ──────────────────────────────────────
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04),
                        child: Container(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Column(
                              children: [
                                const _TableHeader(),
                                Expanded(
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: history.length,
                                    separatorBuilder: (_, _) => Divider(
                                      height: 1,
                                      color: Colors.grey.shade100,
                                    ),
                                    itemBuilder: (ctx, index) {
                                      final r = history[index];
                                      return _HistoryRow(
                                        result: r,
                                        index: index,
                                        scoreColor: _scoreColor(r.score),
                                        dateString:
                                            _formatDateTime(r.finishedAt),
                                        subjectIcon:
                                            subjectIcons[r.subject] ??
                                                Icons.book_rounded,
                                        subjectColor:
                                            subjectColors[r.subject] ??
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                  ],
                ),
          ),  // SafeArea
        );
      },
    );
  }
}

// ── Header ringkasan statistik ─────────────────────────────────────────────────
class _SummaryHeader extends StatelessWidget {
  final List<QuizResult> history;
  final Color primary;
  const _SummaryHeader({required this.history, required this.primary});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final avgScore = history.isEmpty
        ? 0
        : (history.map((r) => r.score).reduce((a, b) => a + b) /
                history.length)
            .round();
    final best =
        history.map((r) => r.score).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      child: Row(
        children: [
          Expanded(
            child: _MiniStatCard(
              label: 'Total Sesi',
              value: '${history.length}',
              icon: Icons.list_alt_rounded,
              color: primary,
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: _MiniStatCard(
              label: 'Rata-rata',
              value: '$avgScore',
              icon: Icons.bar_chart_rounded,
              color: const Color(0xFFFB8C00),
            ),
          ),
          SizedBox(width: size.width * 0.03),
          Expanded(
            child: _MiniStatCard(
              label: 'Tertinggi',
              value: '$best',
              icon: Icons.emoji_events_rounded,
              color: const Color(0xFF43A047),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.014,
        horizontal: size.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: size.width * 0.055),
          SizedBox(height: size.height * 0.005),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.052,
              fontWeight: FontWeight.w800,
              color: color,
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

// ── Header kolom tabel ─────────────────────────────────────────────────────────
class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      color: primary,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.013,
      ),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.055,
            child: Text(
              '#',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.028,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Nama / NIM / Mata Kuliah',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.028,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.15,
            child: Text(
              'Skor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.028,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Waktu',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: size.width * 0.028,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Satu baris riwayat ─────────────────────────────────────────────────────────
class _HistoryRow extends StatelessWidget {
  final QuizResult result;
  final int index;
  final Color scoreColor;
  final String dateString;
  final IconData subjectIcon;
  final Color subjectColor;

  const _HistoryRow({
    required this.result,
    required this.index,
    required this.scoreColor,
    required this.dateString,
    required this.subjectIcon,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isEven = index % 2 == 0;

    return Container(
      color: isEven ? Colors.white : const Color(0xFFFAF9FF),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      child: Row(
        children: [
          // Nomor urut
          SizedBox(
            width: size.width * 0.055,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          // Nama, NIM & mata kuliah
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama
                Text(
                  result.userName,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.032,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                // NIM
                Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      size: size.width * 0.028,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      result.nim,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: size.width * 0.027,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                // Mata kuliah dengan ikon
                Row(
                  children: [
                    Icon(
                      subjectIcon,
                      size: size.width * 0.028,
                      color: subjectColor,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        result.subject,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size.width * 0.025,
                          color: subjectColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Badge skor
          SizedBox(
            width: size.width * 0.15,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                  vertical: size.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scoreColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${result.score}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.036,
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
                ),
              ),
            ),
          ),
          // Tanggal & waktu
          Expanded(
            flex: 2,
            child: Text(
              dateString,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size.width * 0.024,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── State kosong ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Color primary;
  const _EmptyState({required this.primary});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_edu_rounded,
            size: size.width * 0.2,
            color: primary.withValues(alpha: 0.3),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'Belum ada riwayat kuis',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            'Selesaikan kuis pertamamu!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: size.width * 0.036,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
