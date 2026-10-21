import 'package:flutter/material.dart';

/// Helper untuk adaptive & responsive design.
///
/// Menggunakan "capped width" agar proporsi font, padding, dan ukuran
/// widget tetap konsisten di telepon, tablet, maupun web.
class Responsive {
  Responsive._();

  /// Breakpoints
  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && !isLandscape(context);

  static bool isExtraWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900 && !isLandscape(context);

  /// Deteksi landscape di ponsel (lebar > tinggi dan tinggi pendek)
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height && size.height < 500;
  }

  /// Capped width — mensimulasikan lebar layar ponsel (max 450px)
  static double cw(BuildContext context) =>
      MediaQuery.of(context).size.width.clamp(0.0, 450.0);

  /// Di landscape, ukuran font/widget mengacu pada TINGGI layar (lebih kecil),
  /// bukan lebar, karena konten dibagi 2 kolom.
  /// Di portrait / desktop, sama dengan cw.
  static double cwBase(BuildContext context) {
    if (isLandscape(context)) {
      // tinggi landscape ponsel biasanya 360–420px, clamp jadi referensi
      return MediaQuery.of(context).size.height.clamp(0.0, 420.0);
    }
    return cw(context);
  }

  /// Capped height — untuk spacing vertikal agar tidak terlalu kecil di landscape.
  /// Minimum 700px supaya `height * factor` tetap reasonable.
  static double ch(BuildContext context) =>
      MediaQuery.of(context).size.height.clamp(500.0, 1200.0);

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
