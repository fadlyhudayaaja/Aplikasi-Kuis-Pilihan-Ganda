import 'package:flutter/material.dart';
import '../providers/quiz_provider.dart';

/// Tombol toggle tema (light/dark) yang reusable di header tiap halaman.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = QuizProvider.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: state.toggleTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) {
            return ScaleTransition(scale: anim, child: child);
          },
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDark),
            color: theme.colorScheme.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
