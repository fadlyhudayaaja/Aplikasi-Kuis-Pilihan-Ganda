import 'package:flutter/material.dart';
import '../utils/responsive.dart';

/// Tombol kustom reusable yang digunakan di seluruh aplikasi
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cw = Responsive.cw(context);
    final buttonWidth = cw * 0.85;

    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = textColor ?? Colors.white;

    if (isOutlined) {
      return SizedBox(
        width: buttonWidth,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: bgColor, width: 2),
            padding: EdgeInsets.symmetric(vertical: cw * 0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: icon != null
              ? Icon(icon, color: bgColor, size: cw * 0.055)
              : const SizedBox.shrink(),
          label: Text(
            label,
            style: TextStyle(
              color: bgColor,
              fontSize: cw * 0.042,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          padding: EdgeInsets.symmetric(vertical: cw * 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
        icon: icon != null
            ? Icon(icon, size: cw * 0.055)
            : const SizedBox.shrink(),
        label: Text(
          label,
          style: TextStyle(
            fontSize: cw * 0.042,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
