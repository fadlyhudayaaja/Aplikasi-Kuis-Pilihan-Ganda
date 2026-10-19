import 'package:flutter/material.dart';

/// Kartu pemilihan mata kuliah reusable di HomeScreen
class SubjectCard extends StatelessWidget {
  final String subject;
  final String emoji;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.emoji,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final bgColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final textColor = isSelected
        ? Colors.white
        : theme.colorScheme.onSurface;
    final subTextColor = isSelected
        ? Colors.white70
        : theme.colorScheme.onSurfaceVariant;
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline.withOpacity(0.3);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: size.height * 0.007),
        padding: EdgeInsets.all(size.width * 0.04),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            // Emoji ikon mata kuliah
            Container(
              width: size.width * 0.14,
              height: size.width * 0.14,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: size.width * 0.07),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.04),
            // Nama & deskripsi mata kuliah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      color: textColor,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: size.height * 0.004),
                  Text(
                    description,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: size.width * 0.032,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            // Checkmark jika dipilih
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      key: const ValueKey('check'),
                      color: Colors.white,
                      size: size.width * 0.065,
                    )
                  : Icon(
                      Icons.radio_button_unchecked_rounded,
                      key: const ValueKey('uncheck'),
                      color: theme.colorScheme.outline.withOpacity(0.5),
                      size: size.width * 0.065,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
