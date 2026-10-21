import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../utils/responsive.dart';

/// Kartu pemilihan mata kuliah reusable di HomeScreen
/// Menggunakan IconData (bukan emoji) untuk ikon mata kuliah
class SubjectCard extends StatelessWidget {
  final String subject;
  final IconData iconData;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.iconData,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final cw = Responsive.cw(context);
    final accentColor = subjectColors[subject] ?? theme.colorScheme.primary;

    final bgColor = isSelected ? accentColor : theme.colorScheme.surface;
    final textColor = isSelected ? Colors.white : theme.colorScheme.onSurface;
    final subTextColor = isSelected
        ? Colors.white70
        : theme.colorScheme.onSurfaceVariant;
    final borderColor = isSelected
        ? accentColor
        : theme.colorScheme.outline.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: size.height * 0.007),
        padding: EdgeInsets.all(cw * 0.04),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            // Ikon mata kuliah (Material Icon)
            Container(
              width: cw * 0.14,
              height: cw * 0.14,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  iconData,
                  color: isSelected ? Colors.white : accentColor,
                  size: cw * 0.07,
                ),
              ),
            ),
            SizedBox(width: cw * 0.04),
            // Nama & deskripsi mata kuliah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: TextStyle(
                      color: textColor,
                      fontSize: cw * 0.04,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: size.height * 0.004),
                  Text(
                    description,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: cw * 0.032,
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
                      size: cw * 0.065,
                    )
                  : Icon(
                      Icons.radio_button_unchecked_rounded,
                      key: const ValueKey('uncheck'),
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                      size: cw * 0.065,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
