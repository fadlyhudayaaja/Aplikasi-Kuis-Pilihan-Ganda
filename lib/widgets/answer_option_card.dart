import 'package:flutter/material.dart';

/// Kartu pilihan jawaban reusable untuk QuizScreen
class AnswerOptionCard extends StatelessWidget {
  final String label;
  final String optionText;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerOptionCard({
    super.key,
    required this.label,
    required this.optionText,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    Color bgColor;
    Color borderColor;
    Color labelColor;
    Color textColor;
    IconData? trailingIcon;

    switch (state) {
      case AnswerState.correct:
        bgColor = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFF43A047);
        labelColor = const Color(0xFF43A047);
        textColor = const Color(0xFF2E7D32);
        trailingIcon = Icons.check_circle_rounded;
        break;
      case AnswerState.wrong:
        bgColor = const Color(0xFFFFEBEE);
        borderColor = const Color(0xFFE53935);
        labelColor = const Color(0xFFE53935);
        textColor = const Color(0xFFC62828);
        trailingIcon = Icons.cancel_rounded;
        break;
      case AnswerState.selected:
        bgColor = theme.colorScheme.primary.withValues(alpha: 0.12);
        borderColor = theme.colorScheme.primary;
        labelColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.primary;
        trailingIcon = null;
        break;
      case AnswerState.normal:
        bgColor = theme.colorScheme.surface;
        borderColor = theme.colorScheme.outline.withValues(alpha: 0.4);
        labelColor = theme.colorScheme.onSurfaceVariant;
        textColor = theme.colorScheme.onSurface;
        trailingIcon = null;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: size.height * 0.006),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.016,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Label huruf (A, B, C, D)
            Container(
              width: size.width * 0.09,
              height: size.width * 0.09,
              decoration: BoxDecoration(
                color: labelColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.038,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.035),
            // Teks opsi jawaban
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                  color: textColor,
                  fontSize: size.width * 0.038,
                  fontFamily: 'Poppins',
                  fontWeight: state == AnswerState.normal
                      ? FontWeight.w400
                      : FontWeight.w600,
                ),
              ),
            ),
            // Ikon status (benar/salah)
            if (trailingIcon != null)
              Icon(trailingIcon, color: borderColor, size: size.width * 0.06),
          ],
        ),
      ),
    );
  }
}

enum AnswerState { normal, selected, correct, wrong }
