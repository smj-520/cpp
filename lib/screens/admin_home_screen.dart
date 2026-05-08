import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../navigation/app_transitions.dart';
import '../services/app_i18n.dart';
import '../widgets/animated_appear.dart';
import 'settings_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppI18n.t(
            context,
            en: 'Admin Dashboard',
            ar: 'لوحة تحكم المدير',
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: AppI18n.t(context, en: 'Settings', ar: 'الإعدادات'),
            onPressed: () {
              Navigator.of(context).push(
                AppTransitions.fadeSlideSheet(
                  const SettingsScreen(isAdmin: true),
                  routeName: '/settings',
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
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
                      Icons.admin_panel_settings_rounded,
                      size: 76,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedAppear(
                    index: 1,
                    child: Text(
                      AppI18n.t(
                        context,
                        en: 'Welcome, Admin',
                        ar: 'مرحبًا أيها المدير',
                      ),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 28,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedAppear(
                    index: 2,
                    child: Text(
                      user?.email ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedAppear(
                    index: 3,
                    child: Text(
                      AppI18n.t(
                        context,
                        en:
                            'This is your admin area. You can extend this screen with user approvals, reports, and wallet controls.',
                        ar:
                            'هذه منطقة المدير. يمكنك توسيعها بإدارة المستخدمين والتقارير والتحكم بالمحفظة.',
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
        ),
      ),
    );
  }
}
