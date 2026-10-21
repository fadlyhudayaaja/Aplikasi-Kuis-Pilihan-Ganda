import 'package:flutter/material.dart';

/// Helper untuk adaptive & responsive design.
///
/// Menggunakan "capped width" agar proporsi font, padding, dan ukuran
/// widget tetap konsisten di telepon, tablet, maupun web.
class Responsive {
  Responsive._();

  /// Breakpoints
  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static bool isExtraWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  /// Capped width — mensimulasikan lebar layar ponsel (max 450px)
  /// sehingga size.width * factor tidak menggelembung di tablet/web.
  static double cw(BuildContext context) =>
      MediaQuery.of(context).size.width.clamp(0.0, 450.0);

  /// Lebar maksimum konten untuk constrain layout di layar lebar.
  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1200) return 1000;
    if (w >= 900) return 800;
    if (w >= 600) return 560;
    return double.infinity;
  }

  /// Widget pembungkus yang otomatis men-center dan meng-constrain
  /// lebar konten di layar lebar (tablet / web).
  static Widget constrain({
    required BuildContext context,
    required Widget child,
  }) {
    final maxW = maxContentWidth(context);
    if (maxW == double.infinity) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: child,
      ),
    );
  }
}
