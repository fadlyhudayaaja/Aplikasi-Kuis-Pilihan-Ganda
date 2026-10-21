import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Progress bar reusable untuk menunjukkan progres soal di QuizScreen
class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final ch = Responsive.ch(context);
    final theme = Theme.of(context);
    final cw = Responsive.cw(context);
    final progress = total == 0 ? 0.0 : (current + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Soal ${current + 1} dari $total', style: TextStyle(
              fontSize: cw * 0.035, fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant, fontFamily: 'Poppins',
            )),
            Text('${((progress) * 100).round()}%', style: TextStyle(
              fontSize: cw * 0.035, fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary, fontFamily: 'Poppins',
            )),
          ],
        ),
        SizedBox(height: ch * 0.008),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: ch * 0.012,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              );
            },
          ),
        ),
      ],
    );
  }
}
