import 'package:flutter/material.dart';
import 'providers/quiz_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // QuizState hidup di sini agar tidak hilang saat navigasi antar halaman
  final QuizState _quizState = QuizState();

  @override
  Widget build(BuildContext context) {
    return QuizProvider(
      state: _quizState,
      child: ListenableBuilder(
        listenable: _quizState,
        builder: (context, _) {
          return MaterialApp(
            title: 'QuizMate – Kuis Pilihan Ganda',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6C63FF),
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: const Color(0xFFF4F3FF),
              fontFamily: 'Poppins',
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF6C63FF),
                    width: 2,
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6C63FF),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF121212),
              fontFamily: 'Poppins',
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF1E1E2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF3A3A4A),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF8B83FF),
                    width: 2,
                  ),
                ),
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF1E1E2E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: const Color(0xFF1E1E2E),
                indicatorColor:
                    const Color(0xFF6C63FF).withValues(alpha: 0.25),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  final selected =
                      states.contains(WidgetState.selected);
                  return TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? const Color(0xFF8B83FF)
                        : const Color(0xFF9E9EAE),
                  );
                }),
              ),
            ),
            themeMode: _quizState.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
