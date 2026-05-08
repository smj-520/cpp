import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../navigation/app_transitions.dart';
import '../services/user_profile_repository.dart';
import '../widgets/gentle_pulse.dart';
import 'admin_home_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';
import 'user_home_screen.dart';

/// After Firebase is ready: resume an existing session or show splash / login.
class AuthSessionRouter extends StatefulWidget {
  const AuthSessionRouter({super.key});

  @override
  State<AuthSessionRouter> createState() => _AuthSessionRouterState();
}

class _AuthSessionRouterState extends State<AuthSessionRouter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    if (!mounted) return;

    if (Firebase.apps.isEmpty) {
      _replace(const SplashScreen());
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _replace(const SplashScreen());
      return;
    }

    if (!user.emailVerified) {
      _replace(const LoginScreen());
      return;
    }

    String? role;
    try {
      role = await UserProfileRepository()
          .getUserRole(user.uid)
          .timeout(const Duration(seconds: 12));
    } catch (_) {
      role = null;
    }
    if (!mounted) return;

    final normalized = (role ?? 'user').toLowerCase();
    final next =
        normalized == 'admin' ? const AdminHomeScreen() : const UserHomeScreen();

    try {
      await UserProfileRepository().touchLastLogin(user.uid);
    } catch (_) {}

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      AppTransitions.fadeSlide(
        next,
        routeName: normalized == 'admin' ? '/admin-home' : '/user-home',
      ),
    );
  }

  void _replace(Widget page) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      AppTransitions.fade(page, routeName: page.runtimeType.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: GentlePulse(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
