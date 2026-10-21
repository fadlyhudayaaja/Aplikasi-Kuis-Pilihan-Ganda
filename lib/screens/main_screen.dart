import 'package:flutter/material.dart';
import '../providers/quiz_provider.dart';
import '../utils/responsive.dart';
import '../widgets/theme_toggle_button.dart';
import 'home_screen.dart';
import 'history_screen.dart';

/// Halaman utama dengan bottom navigation – Beranda & Histori.
/// Di layar lebar (tablet/web), menggunakan NavigationRail sebagai sidebar.
class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex;
  QuizState? _state;

  _MainScreenState() : _currentIndex = 0;

  void _onStateChanged() {
    if (!mounted || _state == null) return;
    if (_state!.requestedTabIndex != -1) {
      setState(() => _currentIndex = _state!.requestedTabIndex);
      _state!.clearTabRequest();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
    final theme = Theme.of(context);
    final isWide = Responsive.isWide(context);

    final screens = const [
      HomeScreen(),
      HistoryScreen(),
    ];

    final labels = ['Beranda', 'Histori'];
    final icons = [
      Icons.home_outlined,
      Icons.history_outlined,
    ];
    final selectedIcons = [
      Icons.home_rounded,
      Icons.history_rounded,
    ];

    if (isWide) {
      // ── Tablet / Web: NavigationRail di kiri ──
      final isExtraWide = Responsive.isExtraWide(context);
      final sidebarWidth = isExtraWide ? 220.0 : 80.0;

      return Scaffold(
        body: Row(
          children: [
            // Sidebar dengan lebar eksplisit
            SizedBox(
              width: sidebarWidth,
              child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Logo + nama app
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: theme.colorScheme.primary,
                                  child: const Icon(Icons.quiz_rounded,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'QuizMate',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // NavigationRail
                    Expanded(
                      child: NavigationRail(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: (i) =>
                            setState(() => _currentIndex = i),
                        extended: isExtraWide,
                        minExtendedWidth: sidebarWidth,
                        backgroundColor: theme.colorScheme.surface,
                        selectedIconTheme: IconThemeData(
                          color: theme.colorScheme.primary,
                        ),
                        selectedLabelTextStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                        unselectedLabelTextStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        destinations: List.generate(2, (i) {
                          return NavigationRailDestination(
                            icon: Icon(icons[i]),
                            selectedIcon: Icon(selectedIcons[i]),
                            label: Text(labels[i]),
                          );
                        }),
                      ),
                    ),
                    // Theme toggle di bawah sidebar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Row(
                        mainAxisAlignment:
                            Responsive.isExtraWide(context)
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                        children: [
                          const ThemeToggleButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),  // Container
            ),  // SizedBox
            // Konten
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
            ),
          ],
        ),
      );
    }

    // ── Phone: Bottom NavigationBar ──
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: List.generate(2, (i) {
          return NavigationDestination(
            icon: Icon(icons[i]),
            selectedIcon: Icon(selectedIcons[i]),
            label: labels[i],
          );
        }),
      ),
    );
  }
}
