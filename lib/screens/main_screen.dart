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

  /// Membungkus screen dengan Offstage agar child tidak aktif
  /// tidak ikut layout (mencegah overflow di landscape).
  Widget _buildScreen(Widget screen, int index) {
    return Offstage(
      offstage: _currentIndex != index,
      child: TickerMode(
        enabled: _currentIndex == index,
        child: screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = Responsive.isWide(context);
    final isLandscape = Responsive.isLandscape(context);

    const screens = [HomeScreen(), HistoryScreen()];

    final labels = ['Beranda', 'Histori'];
    final icons = [Icons.home_outlined, Icons.history_outlined];
    final selectedIcons = [Icons.home_rounded, Icons.history_rounded];

    if (isWide) {
      // ── Tablet / Web: NavigationRail di kiri ──────────────────────────────
      final isExtraWide = Responsive.isExtraWide(context);
      final sidebarWidth = isExtraWide ? 220.0 : 80.0;

      return Scaffold(
        body: Row(
          children: [
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
                      // Logo + nama app (hanya tampil saat extended)
                      if (isExtraWide)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                                    blurRadius: 8, offset: const Offset(0, 3),
                                  )],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset('assets/images/app_logo.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: theme.colorScheme.primary,
                                      child: const Icon(Icons.quiz_rounded,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(child: Text('QuizMate', style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary, fontFamily: 'Poppins',
                              ))),
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
                            fontFamily: 'Poppins', fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                          unselectedLabelTextStyle: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.w500,
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
                      // Theme toggle
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                        child: Center(child: const ThemeToggleButton()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Konten — pakai Offstage agar tidak ada overflow
            Expanded(
              child: Stack(
                children: List.generate(2, (i) => _buildScreen(screens[i], i)),
              ),
            ),
          ],
        ),
      );
    }

    // ── Phone portrait & landscape: Bottom NavigationBar ─────────────────────
    return Scaffold(
      body: Stack(
        children: List.generate(2, (i) => _buildScreen(screens[i], i)),
      ),
      bottomNavigationBar: isLandscape
          // Landscape: compact tanpa label
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              height: 48,
              destinations: List.generate(2, (i) => NavigationDestination(
                icon: Icon(icons[i]),
                selectedIcon: Icon(selectedIcons[i]),
                label: labels[i],
              )),
            )
          // Portrait: normal
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => setState(() => _currentIndex = i),
              destinations: List.generate(2, (i) => NavigationDestination(
                icon: Icon(icons[i]),
                selectedIcon: Icon(selectedIcons[i]),
                label: labels[i],
              )),
            ),
    );
  }
}
