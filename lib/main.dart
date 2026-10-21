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
            // SplashScreen sebagai halaman pertama
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
