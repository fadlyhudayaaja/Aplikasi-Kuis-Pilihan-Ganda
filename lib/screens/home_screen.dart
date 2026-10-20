import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../providers/quiz_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/subject_card.dart';
import 'history_screen.dart';
import 'quiz_screen.dart';

/// Halaman Awal – input nama, pilih mata kuliah, mulai kuis atau lihat riwayat
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
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
    _headerFade = CurvedAnimation(
      parent: _headerAnimCtrl,
      curve: Curves.easeOut,
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerAnimCtrl, curve: Curves.easeOut));
    _headerAnimCtrl.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headerAnimCtrl.dispose();
    super.dispose();
  }

  void _startQuiz() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih mata kuliah terlebih dahulu!',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final state = QuizProvider.of(context);
    state.startQuiz(
      userName: _nameController.text.trim(),
      subject: _selectedSubject!,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: const QuizScreen(),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.04),

                // ── Header ──────────────────────────────────────────────────
                SlideTransition(
                  position: _headerSlide,
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(0.7)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.quiz_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'QuizMate',
                                  style: TextStyle(
                                    fontSize: size.width * 0.065,
                                    fontWeight: FontWeight.w800,
                                    color: primaryColor,
                                    fontFamily: 'Poppins',
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Kuis Pilihan Ganda – Fasilkom-TI USU',
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.025),

                        // Banner card selamat datang
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(size.width * 0.05),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                const Color(0xFF8B83FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selamat Datang! 👋',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.048,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.006),
                                    Text(
                                      'Isi namamu & pilih mata kuliah\nuntuk memulai kuis.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontSize: size.width * 0.033,
                                        fontFamily: 'Poppins',
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '🎓',
                                style: TextStyle(fontSize: size.width * 0.15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.035),

                // ── Form Input Nama ──────────────────────────────────────────
                _SectionLabel(label: 'Nama Peserta'),
                SizedBox(height: size.height * 0.012),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.04,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama lengkap...',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: size.width * 0.038,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: primaryColor,
                    ),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),

                SizedBox(height: size.height * 0.03),

                // ── Pilihan Mata Kuliah ──────────────────────────────────────
                _SectionLabel(label: 'Pilih Mata Kuliah'),
                SizedBox(height: size.height * 0.012),
                ...subjects.map((subject) {
                  return SubjectCard(
                    subject: subject,
                    emoji: subjectIcons[subject] ?? '📚',
                    description: subjectDescriptions[subject] ?? '',
                    isSelected: _selectedSubject == subject,
                    onTap: () => setState(() => _selectedSubject = subject),
                  );
                }),

                SizedBox(height: size.height * 0.035),

                // ── Tombol Mulai Kuis ────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      CustomButton(
                        label: 'Mulai Kuis',
                        onPressed: _startQuiz,
                        icon: Icons.play_arrow_rounded,
                        backgroundColor: primaryColor,
                      ),
                      SizedBox(height: size.height * 0.016),
                      CustomButton(
                        label: 'Lihat Riwayat',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryScreen(),
                            ),
                          );
                        },
                        icon: Icons.history_rounded,
                        isOutlined: true,
                        backgroundColor: primaryColor,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Label section heading reusable di dalam layar ini ─────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Text(
      label,
      style: TextStyle(
        fontSize: size.width * 0.042,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'Poppins',
      ),
    );
  }
}
