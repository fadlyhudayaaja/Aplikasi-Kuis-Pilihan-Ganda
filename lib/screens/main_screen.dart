import 'package:flutter/material.dart';
import '../providers/quiz_provider.dart';
import 'home_screen.dart';
import 'history_screen.dart';

/// Halaman utama dengan bottom navigation – Beranda & Histori
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  QuizState? _state;

  void _onStateChanged() {
    if (!mounted || _state == null) return;
    if (_state!.requestedTabIndex != -1) {
      setState(() => _currentIndex = _state!.requestedTabIndex);
      _state!.clearTabRequest();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_state == null) {
      _state = QuizProvider.of(context);
      _state!.addListener(_onStateChanged);
    }
  }

  @override
  void dispose() {
    _state?.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'Histori',
          ),
        ],
      ),
    );
  }
}
