import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'main_screen.dart';

/// Halaman splash animasi saat pertama kali membuka aplikasi
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controller untuk logo (scale + fade)
  late AnimationController _logoCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  // Controller untuk teks nama aplikasi (slide dari bawah)
  late AnimationController _textCtrl;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  // Controller untuk tagline
  late AnimationController _taglineCtrl;
  late Animation<double> _taglineFade;

  // Controller untuk exit (fade out seluruh layar)
  late AnimationController _exitCtrl;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);

    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineFade = CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut);

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _taglineCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1400));
    await _exitCtrl.forward();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const MainScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _taglineCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cw = Responsive.cw(context);

    return AnimatedBuilder(
      animation: _exitFade,
      builder: (context, child) {
        return Opacity(
          opacity: _exitFade.value,
          child: child,
        );
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4A42D6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // ── Dekorasi lingkaran latar belakang (capped) ────────────
              Positioned(
                top: -cw * 0.25,
                right: -cw * 0.2,
                child: Container(
                  width: cw * 0.7,
                  height: cw * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: -cw * 0.3,
                left: -cw * 0.2,
                child: Container(
                  width: cw * 0.8,
                  height: cw * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),

              // ── Konten tengah ─────────────────────────────────────────
              Center(
                child: Responsive.constrain(
                  context: context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo animasi
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: _LogoWidget(cw: cw),
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      // Nama aplikasi
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: Text(
                            'QuizMate',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: cw * 0.1,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.008),

                      // Tagline
                      FadeTransition(
                        opacity: _taglineFade,
                        child: Column(
                          children: [
                            Text(
                              'Kuis Pilihan Ganda',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: cw * 0.042,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: size.height * 0.006),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'IKLC Fasilkom-TI USU',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: cw * 0.032,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Loading dots di bawah ─────────────────────────────────
              Positioned(
                bottom: size.height * 0.08,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: const _LoadingDots(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget Logo utama dengan gambar app_logo.png ─────────────────────────────
class _LogoWidget extends StatelessWidget {
  final double cw;
  const _LogoWidget({required this.cw});

  @override
  Widget build(BuildContext context) {
    final logoSize = cw * 0.38;
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cw * 0.08),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
            blurRadius: 60,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cw * 0.08),
        child: Image.asset(
          'assets/images/app_logo.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: Colors.white,
            child: Icon(
              Icons.quiz_rounded,
              color: const Color(0xFF6C63FF),
              size: cw * 0.16,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animasi loading dots ──────────────────────────────────────────────────────
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) {
            final delay = i * 0.33;
            final t = (_ctrl.value - delay).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            );
          },
        );
      }),
    );
  }
}
