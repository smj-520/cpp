import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/app_i18n.dart';
import '../widgets/animated_appear.dart';
import 'settings_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';

    final pages = <Widget>[
      _UserDashboard(email: email),
      _UserEmptyTab(
        icon: Icons.receipt_long_outlined,
        titleEn: 'Transactions',
        titleAr: 'المعاملات',
      ),
      _UserEmptyTab(
        icon: Icons.add_circle_outline_rounded,
        titleEn: 'Add',
        titleAr: 'إضافة',
      ),
      _UserEmptyTab(
        icon: Icons.pie_chart_outline_rounded,
        titleEn: 'Report',
        titleAr: 'تقرير',
      ),
      const SettingsScreen(isAdmin: false),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _index == 4
          ? null
          : AppBar(
              title: Text(
                AppI18n.t(
                  context,
                  en: 'User Home',
                  ar: 'الصفحة الرئيسية للمستخدم',
                ),
              ),
              automaticallyImplyLeading: false,
            ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_index),
            child: pages[_index],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (next) => setState(() => _index = next),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: AppI18n.t(context, en: 'Home', ar: 'الرئيسية'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long_rounded),
            label: AppI18n.t(context, en: 'Transactions', ar: 'المعاملات'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle_rounded),
            label: AppI18n.t(context, en: 'Add', ar: 'إضافة'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline),
            selectedIcon: const Icon(Icons.pie_chart_rounded),
            label: AppI18n.t(context, en: 'Report', ar: 'تقرير'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: AppI18n.t(context, en: 'Settings', ar: 'الإعدادات'),
          ),
        ],
      ),
    );
  }
}

class _UserDashboard extends StatelessWidget {
  const _UserDashboard({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pad = constraints.maxWidth >= 600 ? 32.0 : 24.0;
        final maxW = (constraints.maxWidth * 0.92).clamp(320.0, 560.0);
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(pad),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedAppear(
                    index: 0,
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 76,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedAppear(
                    index: 1,
                    child: Text(
                      AppI18n.t(context, en: 'Welcome', ar: 'مرحبًا'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 28,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedAppear(
                    index: 2,
                    child: Text(
                      email,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedAppear(
                    index: 3,
                    child: Text(
                      AppI18n.t(
                        context,
                        en: 'Track your wallet activity from this home page.',
                        ar: 'تابع نشاط المحفظة من هذه الصفحة الرئيسية.',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserEmptyTab extends StatelessWidget {
  const _UserEmptyTab({
    required this.icon,
    required this.titleEn,
    required this.titleAr,
  });

  final IconData icon;
  final String titleEn;
  final String titleAr;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: scheme.primary.withValues(alpha: 0.85)),
            const SizedBox(height: 16),
            Text(
              AppI18n.t(context, en: titleEn, ar: titleAr),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppI18n.t(
                context,
                en: 'This section is not available yet.',
                ar: 'هذا القسم غير متوفر بعد.',
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.72),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
