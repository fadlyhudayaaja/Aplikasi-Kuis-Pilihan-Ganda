import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/subject_card.dart';
import '../widgets/theme_toggle_button.dart';
import 'quiz_screen.dart';

/// Halaman Awal – input nama, NIM, pilih mata kuliah, mulai kuis
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedSubject;
  late AnimationController _headerAnimCtrl;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _headerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade = CurvedAnimation(parent: _headerAnimCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerAnimCtrl, curve: Curves.easeOut));
    _headerAnimCtrl.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _headerAnimCtrl.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih mata kuliah terlebih dahulu!',
              style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final state = QuizProvider.of(context);
    state.startQuiz(
      userName: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      subject: _selectedSubject!,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, _) => FadeTransition(
          opacity: anim,
          child: const QuizScreen(),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final cw = Responsive.cw(context);
    final ch = Responsive.ch(context);
    final isLandscape = Responsive.isLandscape(context);
    final cb = Responsive.cwBase(context); // base ukuran font/spacing

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Responsive.constrain(
          context: context,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: cw * 0.06),
            child: Form(
              key: _formKey,
              child: isLandscape
                  ? _buildLandscape(cw, ch, theme, primaryColor, cb)
                  : _buildPortrait(cw, ch, theme, primaryColor, cb),
            ),
          ),
        ),
      ),
    );
  }

  // ── Layout Portrait (default) ──────────────────────────────────────────────
  Widget _buildPortrait(double cw, double ch, ThemeData theme, Color primaryColor, double cb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ch * 0.04),
        _buildHeader(cw, ch, theme, primaryColor, cb),
        SizedBox(height: ch * 0.035),
        _SectionLabel(label: 'Identitas Peserta', cw: cb),
        SizedBox(height: ch * 0.012),
        _buildNameField(cb, theme, primaryColor),
        SizedBox(height: ch * 0.016),
        _buildNimField(cb, theme, primaryColor),
        SizedBox(height: ch * 0.03),
        _SectionLabel(label: 'Pilih Mata Kuliah', cw: cb),
        SizedBox(height: ch * 0.012),
        ...subjects.map((subject) => _buildSubjectCard(subject)),
        SizedBox(height: ch * 0.035),
        Center(child: _buildStartButton(primaryColor)),
        SizedBox(height: ch * 0.04),
      ],
    );
  }

  // ── Layout Landscape (2 kolom) ─────────────────────────────────────────────
  Widget _buildLandscape(double cw, double ch, ThemeData theme, Color primaryColor, double cb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        // Header compact di landscape
        SlideTransition(
          position: _headerSlide,
          child: FadeTransition(
            opacity: _headerFade,
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.25),
                      blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/images/app_logo.png', fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: primaryColor,
                        child: const Icon(Icons.quiz_rounded, color: Colors.white, size: 18))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('QuizMate – Kuis Pilihan Ganda', style: TextStyle(
                  fontSize: cb * 0.042, fontWeight: FontWeight.w800,
                  color: primaryColor, fontFamily: 'Poppins'))),
                if (!Responsive.isWide(context)) const ThemeToggleButton(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 2 kolom
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'Identitas Peserta', cw: cb),
                  const SizedBox(height: 8),
                  _buildNameField(cb, theme, primaryColor),
                  const SizedBox(height: 8),
                  _buildNimField(cb, theme, primaryColor),
                  const SizedBox(height: 12),
                  _buildStartButton(primaryColor),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'Pilih Mata Kuliah', cw: cb),
                  const SizedBox(height: 8),
                  ...subjects.map((subject) => _buildSubjectCard(subject)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Header (portrait) ──────────────────────────────────────────────────────
  Widget _buildHeader(double cw, double ch, ThemeData theme, Color primaryColor, double cb) {
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.25),
                        blurRadius: 10, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset('assets/images/app_logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.quiz_rounded, color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('QuizMate', style: TextStyle(
                        fontSize: cb * 0.065, fontWeight: FontWeight.w800,
                        color: primaryColor, fontFamily: 'Poppins', letterSpacing: -0.5,
                      )),
                      Text('Kuis Pilihan Ganda – Fasilkom-TI USU', style: TextStyle(
                        fontSize: cb * 0.03,
                        color: theme.colorScheme.onSurfaceVariant, fontFamily: 'Poppins',
                      )),
                    ],
                  ),
                ),
                if (!Responsive.isWide(context))
                  const ThemeToggleButton(),
              ],
            ),
            SizedBox(height: ch * 0.025),
            // Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(cw * 0.05),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, const Color(0xFF8B83FF)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20, offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat Datang! 👋', style: TextStyle(
                          color: Colors.white, fontSize: cb * 0.048,
                          fontWeight: FontWeight.w700, fontFamily: 'Poppins',
                        )),
                        SizedBox(height: ch * 0.006),
                        Text('Isi identitasmu & pilih mata kuliah\nuntuk memulai kuis.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: cb * 0.033, fontFamily: 'Poppins', height: 1.5,
                          )),
                      ],
                    ),
                  ),
                  Icon(Icons.school_rounded,
                    color: Colors.white.withValues(alpha: 0.4), size: cw * 0.18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Form fields ────────────────────────────────────────────────────────────
  Widget _buildNameField(double cw, ThemeData theme, Color primaryColor) {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontFamily: 'Poppins', fontSize: cw * 0.04),
      decoration: InputDecoration(
        hintText: 'Nama lengkap...',
        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: cw * 0.038,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
        prefixIcon: Icon(Icons.person_outline_rounded, color: primaryColor),
        fillColor: theme.colorScheme.surface,
        labelText: 'Nama',
        labelStyle: TextStyle(fontFamily: 'Poppins', color: primaryColor, fontSize: cw * 0.036),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Nama tidak boleh kosong';
        if (value.trim().length < 3) return 'Nama minimal 3 karakter';
        return null;
      },
    );
  }

  Widget _buildNimField(double cw, ThemeData theme, Color primaryColor) {
    return TextFormField(
      controller: _nimController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontFamily: 'Poppins', fontSize: cw * 0.04, letterSpacing: 1.2),
      decoration: InputDecoration(
        hintText: 'Nomor Induk Mahasiswa...',
        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: cw * 0.038, letterSpacing: 0,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
        prefixIcon: Icon(Icons.badge_outlined, color: primaryColor),
        fillColor: theme.colorScheme.surface,
        labelText: 'NIM',
        labelStyle: TextStyle(fontFamily: 'Poppins', color: primaryColor, fontSize: cw * 0.036),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'NIM tidak boleh kosong';
        if (value.trim().length < 6) return 'NIM minimal 6 digit';
        return null;
      },
    );
  }

  Widget _buildSubjectCard(String subject) {
    return SubjectCard(
      subject: subject,
      iconData: subjectIcons[subject] ?? Icons.book_rounded,
      description: subjectDescriptions[subject] ?? '',
      isSelected: _selectedSubject == subject,
      onTap: () => setState(() => _selectedSubject = subject),
    );
  }

  Widget _buildStartButton(Color primaryColor) {
    return CustomButton(
      label: 'Mulai Kuis',
      onPressed: _startQuiz,
      icon: Icons.play_arrow_rounded,
      backgroundColor: primaryColor,
    );
  }
}

// ── Label section heading ──────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final double cw;
  const _SectionLabel({required this.label, required this.cw});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(
      fontSize: cw * 0.042, fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface, fontFamily: 'Poppins',
    ));
  }
}
